//
//  ContentView.swift
//  QR
//
//  Created by Daniel Gehrman on 19.02.2026.
//

import SwiftUI
import QRCode
import UniformTypeIdentifiers

struct QR: Transferable {
    var content = ""

    // Generate a UIKit image to encode to PNG
    var uiImage: UIImage {
        do {
            let doc = try QRCode.Document(utf8String: content)
            let cg = try doc.cgImage(dimension: 400)
            return UIImage(cgImage: cg)
        } catch {
            print("QR generation failed:", error)
            return UIImage(named: "default-qr") ?? UIImage()
        }
    }

    var image: Image { Image(uiImage: uiImage) }

//    static var transferRepresentation: some TransferRepresentation {
//        FileRepresentation(exportedContentType: .png) { qr in
//            let url = FileManager.default.temporaryDirectory
//                .appendingPathComponent("QRCode")
//                .appendingPathExtension("png")
//
//            try (qr.uiImage.pngData() ?? Data()).write(to: url, options: [.atomic])
//            return SentTransferredFile(url)
//        }
//    }
    
    static var transferRepresentation: some TransferRepresentation {
        
        // option 1 (file url)
        FileRepresentation(exportedContentType: .png) { qr in
            let filename = "QRCode.png"
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent(filename)

            guard let data = qr.uiImage.pngData() else {
                throw CocoaError(.fileWriteUnknown)
            }

            try data.write(to: url, options: [.atomic])
            return SentTransferredFile(url)
        }
        
        // option 2 (raw png)
        DataRepresentation(exportedContentType: .png) { qr in
            guard let data = qr.uiImage.pngData() else {
                throw CocoaError(.fileWriteUnknown)
            }
            return data
        }

        // option 3 (raw jpeg)
        DataRepresentation(exportedContentType: .jpeg) { qr in
            guard let data = qr.uiImage.jpegData(compressionQuality: 0.95) else {
                throw CocoaError(.fileWriteUnknown)
            }
            return data
        }
        
        // option 4
        ProxyRepresentation(exporting: \.image)

    }
}

struct ContentView: View {
    
    @State var qr = QR(content: "")
    
    @State var isShowingInfoSheet = false

    var body: some View {
        NavigationStack{
            VStack(spacing: 16) {
                
                Spacer()
                
                qr.image
                    .interpolation(.none)   // keeps it crisp
                    .resizable()
                    .frame(width: 200, height: 200)
                
                TextField(
                    "Enter your text here!",
                    text: $qr.content
                )
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                //
                //            Button(action: copyImageToClipboard) {
                //                Text("Sign In")
                //            }
                
                Spacer()
                
                ZStack {
                    ShareLink(
                        item: qr,
                        preview: SharePreview("QR Code", image: qr.image)
                    ) {
                        Label("Share QR Code", systemImage: "square.and.arrow.up")
                    }
                    
                    HStack () {
                        Spacer()
                        
                        Button(action: {isShowingInfoSheet.toggle()}) {
                            Image(systemName: "info.circle.text.page")
                        }
                        .sheet(isPresented: $isShowingInfoSheet) {
                            AcknowledgementsVIew()
//                            VStack {
//                                Text("Acknowledgements")
//                                    .font(.title)
//                                    .padding(50)
//                                    
//                                
//                            }
                        }
                    }
                }

            }
            .padding([.bottom, .horizontal])
            .navigationTitle("QR Generator")
        }
    }
}

#Preview {
    ContentView()
}
