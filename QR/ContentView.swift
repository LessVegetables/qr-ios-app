//
//  ContentView.swift
//  QR
//
//  Created by Daniel Gehrman on 19.02.2026.
//

import SwiftUI
import QRCode

struct ContentView: View {
    
    @State var qr_code_text = "content"
    
    private var qrCGImage: CGImage? {
        do {
            let doc = try QRCode.Document(utf8String: qr_code_text)
            return try doc.cgImage(dimension: 400)
        } catch {
            print("QR generation failed:", error)
            return nil
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            if let qrCGImage {
                Image(decorative: qrCGImage, scale: 1)
                    .interpolation(.none)   // keeps it crisp
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Text("Couldn’t generate QR code")
                    .foregroundStyle(.secondary)
            }

            TextField(
                "Input",
                text: $qr_code_text
            )
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
//            
//            Button(action: copyImageToClipboard) {
//                Text("Sign In")
//            }
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
