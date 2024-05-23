//
//  PopUpView.swift
//  FileStructure
//
//  Created by Varsha Verma on 13/05/24.
//

import SwiftUI

struct PopUpView: View {
    @Binding var txt : String
    @Binding var isPresented: Bool
    
    @Environment(\.dismiss) var dismiss

    
    var parentId : String
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.green)
                .frame(height: 300)
                .cornerRadius(40)
                .padding(20)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image("Close")
                            .resizable()
                            .frame(width: 40,height: 40)
                    }
                    Text("        ")
                }
                TextField("Enter Folder Name", text: $txt)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button {
                    PersistenceController.shared.addItem(name: self.txt, pId: parentId)
                    //isPresented = false
                    dismiss()
                } label: {
                    Text("Add")
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .cornerRadius(10)
                }
                .background(Color.red) // Set background color to blue
                .foregroundColor(.white)
            }
        }
    }
}


