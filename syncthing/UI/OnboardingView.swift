// The MIT License (MIT)
//
// Copyright (C) 2024-2025 Tommy van der Vorst
// Copyright (C) 2026 The syncthing-macos Authors. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import Foundation
import SwiftUI

struct FeatureView: View {
	var image: String
	var title: String
	var description: String

	var body: some View {
		HStack(alignment: .top, spacing: 15) {
			Image(systemName: image).foregroundColor(.accentColor)
				.font(.system(size: 38, weight: .light))
			VStack(alignment: .leading, spacing: 5) {
				Text(self.title).bold()
				Text(self.description)
				Spacer()
			}
		}
	}
}

struct OnboardingView: View {
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		ScrollView(.vertical) {
			VStack(alignment: .leading, spacing: 20) {
				self.title

				HStack(alignment: .center) {
					Text("Synchronize your files securely with your other devices.")
						.bold()
						.multilineTextAlignment(.leading)
						.fixedSize(horizontal: false, vertical: true)
				}.frame(
					minWidth: 0,
					minHeight: 0,
					maxHeight: .infinity,
					alignment: .topLeading
				)

				Text("Before we start, we need to go over a few things:").multilineTextAlignment(
					.leading)

				FeatureView(
					image: "bolt.horizontal.circle",
					title: String(localized: "Synchronization is not back-up"),
					description: String(
						localized:
							"When you synchronize files, all changes, including deleting files, also happen on your other devices. Do not use Syncthing for back-up purposes, and always keep a back-up of your data."
					))

				FeatureView(
					image: "hand.raised.circle",
					title: String(localized: "Your devices, your data, your responsibility"),
					description: String(
						localized:
							"You decide with which devices you share your data with. Syncthing is a selfhosted secure Peer-to-peer app without a central server or cloud service. This also means the app makers cannot help you access or recover any lost files."
					)
				)

				FeatureView(
					image: "gear.circle",
					title: String(localized: "Powered by Syncthing"),
					description: String(
						localized:
							"This app is powered by the official Open source Syncthing."
					)
				)

				self.footer.padding(.bottom).padding(10)

			}.padding(.all).padding(20)
		}
	}

	var title: some View {
		Text(
			"Welcome to Syncthing for macOS!"
		)
		.font(.largeTitle.bold())
		.multilineTextAlignment(.center)
	}

	var footer: some View {
		Color.blue
			.frame(
				minHeight: 48, maxHeight: .infinity
			)
			.cornerRadius(9.0)
			.overlay(alignment: .center) {
				Text("I understand, let's get started!").bold().foregroundColor(.white)
			}.onTapGesture {
				self.dismiss()
			}
	}
}

#Preview {
	OnboardingView()
}
