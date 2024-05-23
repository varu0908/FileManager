//
//  ContentView.swift
//  FileStructure
//
//  Created by Varsha Verma on 13/05/24.
//

import SwiftUI
import CoreData
import PDFKit

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            ContentView2(parentId: "")
        }
    }
}


struct ContentView2: View {
    
    @State private var isPresent = false
    @State private var textFromPopup = ""
    @State private var showingDocumentPicker = false
    @State private var selectedURL: String?
    
    var parentId : String = ""
    
   
    init(parentId: String ) {
        self.parentId = parentId
    }
    @Environment(\.managedObjectContext) private var viewContext
    @State var items = [Folder]()
    
    var body: some View {
        
        VStack{
            if items.count == 0{
                Text("No Result Found!")
                    .font(.headline)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .padding(.top,100)
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink {
                            if item.isFolder{
                                ContentView2(parentId: item.id ?? "")
                            }else{
                                PDFUIView(url: item.url ?? "")
                              //  UIApplication.shared.open(URL(fileURLWithPath: item.url ?? "")!)
                              //  Link("Some label", destination: URL(string: item.url ?? "")!)
                            }
                            
                          //  UIApplication.shared.open(URL(fileURLWithPath: item.url ?? ""))
                           // ContentView2(parentId: item.id ?? "")
                        } label: {
                            CustomCollectionViewCell(folder: item)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            HStack {
                VStack {
                    Button {
                        isPresent = true
                    } label: {
                        Image("folder")
                            .resizable()
                            .frame(width: 50,height: 50)
                    }
                    Text("Folder")
                }
                VStack {
                    Button {
                        showingDocumentPicker.toggle()
                    } label: {
                        Image("file")
                            .resizable()
                            .frame(width: 50,height: 50)
                    }
                    Text("FILE")
                        .sheet(isPresented: $showingDocumentPicker) {
                            DocumentPicker(selectedURL: $selectedURL, id: self.parentId, onDismiss: {
                                showingDocumentPicker = false
                        })
                    }
                }
            }
            .popover(isPresented:  $isPresent, content: {
                PopUpView(txt: $textFromPopup, isPresented: $isPresent, parentId: self.parentId)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .onAppear(){
                fetchRecords(with: self.parentId)
            }
            .onChange(of: isPresent) { newValue in
                fetchRecords(with: self.parentId)
            }
            .onChange(of: showingDocumentPicker) { newValue in
                fetchRecords(with: self.parentId)
            }
        }
    }
    
    private func fetchRecords(with value: String) {
           let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
           let predicate = NSPredicate(format: "parentId = %@", value)
           fetchRequest.predicate = predicate

           do {
               let fetchedRecords = try viewContext.fetch(fetchRequest)
               items = fetchedRecords
           } catch let error as NSError {
               // Handle any errors
               print("Could not fetch. \(error), \(error.userInfo)")
           }
       }
    
}

struct CustomCollectionViewCell: View {
    let folder : Folder

    var body: some View {
        VStack {
            Image(folder.isFolder ?  "folder" : "file")
                    .resizable()
                    .frame(width: 60,height: 60)
            Text(folder.name ?? "")
                .foregroundColor(.black)
                .padding()
                .cornerRadius(8)
                .lineLimit(2)
                .frame(height: 30)
        }
        .frame(width: 100, height: 100)
        .cornerRadius(8)
        .padding(4)
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let pdfDocument: PDFDocument
    
    init(showing pdfDoc: PDFDocument) {
        self.pdfDocument = pdfDoc
    }
    
    //you could also have inits that take a URL or Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

struct PDFUIView: View {
    
    var pdfDoc: PDFDocument?
    var url : String
    
    init(url : String) {
        self.url = url
        //for the sake of example, we're going to assume
        //you have a file Lipsum.pdf in your bundle
        pdfDoc = PDFDocument(url: URL.init(string: url)!)!
    }
    
    var body: some View {
        PDFKitView(showing: pdfDoc!)
    }
}
