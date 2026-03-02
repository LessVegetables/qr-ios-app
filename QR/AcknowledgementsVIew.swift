//
//  AcknowledgementsVIew.swift
//  QR
//
//  Created by Daniel Gehrman on 01.03.2026.
//

import SwiftUI


struct OpenSource: Identifiable {
    let name: String
    let id = UUID()
    let url: String
}

private var sources = [
    OpenSource(name: "QRCode", url: "https://github.com/dagronf/qrcode"),
    OpenSource(name: "swift-qrcode-generator", url: "https://github.com/fwcd/swift-qrcode-generator"),
    OpenSource(name: "SwiftImageReadWrite", url: "https://swiftpackageindex.com/dagronf/SwiftImageReadWrite/main/documentation/swiftimagereadwrite)"),
]


struct AcknowledgementsVIew: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("App Version: \(getAppVersion())")){
                    Text("A simple pet-project app, made by [Daniel Gehrman](https://www.d.gehrman.me/apps/qr)")
                        .font(.subheadline)
                        .tint(.accentColor)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            
                Section(header: Text("QR uses this open source software")) {
                    ForEach(sources) { source in
                        Link(source.name, destination: URL(string: source.url)!)
                            .tint(.accentColor)
                    }
                }
            }
            .navigationTitle("About QR")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)

        } detail: {
            Text("Select a source")
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
    
    
    func getAppVersion() -> String {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return appVersion
            }
            return "Unknown"
        }
}

#Preview {
        AcknowledgementsVIew()
}
