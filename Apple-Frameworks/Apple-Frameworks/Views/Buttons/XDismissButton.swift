//
//  XDismissButton.swift
//  Apple-Frameworks
//
//  Created by Boyuan Jiang on 8/5/2024.
//

import SwiftUI

struct XDismissButton: View {
    
    @Binding var isShowingDetailView: Bool
    
    var body: some View {
        // Human Interface Guideline
        // an exit button from modality
        
        HStack { // push button to right
            Spacer()
            
            Button {
                isShowingDetailView = false
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.label))
                    .imageScale(.large)
                    .frame(width: 44, height: 44) // larger area for the user to "click"
            }
        }
        .padding()
    }
    
}

#Preview {
    XDismissButton(isShowingDetailView: .constant(false))
}
