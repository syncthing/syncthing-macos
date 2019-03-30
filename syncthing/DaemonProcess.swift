//
//  DaemonProcess.swift
//  syncthing
//
//  Created by Jakob Borg on 2018-07-29.
//  Copyright © 2018 The syncthing-macos Authors. All rights reserved.
//

import Foundation

let RestartInterval = 10.0 // seconds
let MaxKeepLogLines = 200

@objc public protocol DaemonProcessDelegate: class {
    func process(_: DaemonProcess, isRunning: Bool)
}

@objc public class DaemonProcess: NSObject {
    private var path: String
    private weak var delegate: DaemonProcessDelegate?
    private var process: Process?
    private var log = [String]()
    private var queue = DispatchQueue(label: "DaemonProcess")
    private var shouldTerminate = false

    @objc init(path: String, delegate: DaemonProcessDelegate) {
        self.path = path
        self.delegate = delegate
    }

    @objc func launch() {
        queue.async {
            self.launchSync()
        }
    }

    @objc func terminate() {
        queue.async {
            self.shouldTerminate = true
            self.process?.terminate()
        }
    }

    @objc func restart() {
        queue.async {
            // Syncthing should exit cleanly when sent the interrupt signal. It will then be restarted.
            self.process?.interrupt()
        }
    }

    private func launchSync() {
        NSLog("Launching Syncthing daemon")
        shouldTerminate = false

        let p = Process()
        p.arguments = ["-no-browser", "-no-restart"]
        p.launchPath = path
        p.standardInput = Pipe() // isolate daemon from our stdin
        p.standardOutput = pipeIntoLineBuffer()
        p.standardError = pipeIntoLineBuffer()
        p.terminationHandler = { p in self.queue.async { self.didTerminate(p) } }
        p.qualityOfService = QualityOfService.background
        p.launch()

        DispatchQueue.main.async {
            self.delegate?.process(self, isRunning: true)
        }

        process = p
    }

    private func didTerminate(_ p: Process) {
        NSLog("Syncthing daemon terminated (exit code %d)", p.terminationStatus)
        process = nil

        DispatchQueue.main.async {
            self.delegate?.process(self, isRunning: false)
        }

        if shouldTerminate {
            return
        }
        var delay = 0.0
        switch p.terminationStatus {
        case 0:
            // Successfull exit, such as when told to stop. We ignore
            // that fact and restart anyway, with no delay. TODO(jb):
            // Consider instead offering a "restart daemon" command in
            // the menu?
            break
        case 3:
            // Restarting. No delay necessary.
            break
        default:
            // Anything else is an error condition of some kind. Delay
            // the startup to not get caught in a tight loop.
            delay = RestartInterval
            NSLog("Delaying daemon startup by %.1f s", delay)
        }
        queue.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.launchSync()
        }
    }

    private func pipeIntoLineBuffer() -> Pipe {
        let p = Pipe()
        p.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if data.count == 0 {
                // No data available means EOF; we must unregister ourselves
                // in order to not immediately be called again.
                handle.readabilityHandler = nil
                return
            }

            guard let str = String(data: data, encoding: .utf8) else {
                // Non-UTF-8 data from Syncthing should never happen.
                return
            }

            print(str, terminator: "")
            self.queue.async {
                self.log.append(contentsOf: str.components(separatedBy: "\n"))
                if self.log.count > MaxKeepLogLines {
                    self.log.removeFirst(self.log.count - MaxKeepLogLines)
                }
            }
        }
        return p
    }
}
