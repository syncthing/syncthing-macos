//
//  OnboardingViewFactory.swift
//  syncthing
//
//  Created by Jerry Jacobs on 25/08/2025.
//  Copyright © 2025 syncthing-macos authors. All rights reserved.
//
import SwiftUI
import AppKit

// Use @objcMembers to expose this class and its methods to Objective-C.
@objcMembers
public final class OnboardingViewFactory: NSObject {

    // This factory method returns an NSViewController that can be used in AppKit.
    public static func makeOnboardingViewController() -> NSViewController {
        // 1. Instantiate your SwiftUI view.
        let onboardingView = OnboardingView()

        // 2. Wrap it in an NSHostingController.
        let hostingController = NSHostingController(rootView: onboardingView)

        // 3. Return it as a standard NSViewController.
        return hostingController
    }
}
