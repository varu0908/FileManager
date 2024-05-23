//
//  DocumentPicker.swift
//  FileStructure
//
//  Created by Varsha Verma on 15/05/24.
//

import SwiftUI
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: String?
    var id  : String
    var onDismiss: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let url  = urls.first?.absoluteString ?? ""
            parent.selectedURL = url
            PersistenceController().addItem(name:  urls.first?.lastPathComponent ?? "File", pId: parent.id,isFolder: false, url: url)
            parent.onDismiss?()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onDismiss?()
        }
    }
}
