//
//  FrameworkDetailedView.swift
//  Apple-Frameworks
//
//  Created by Boyuan Jiang on 7/5/2024.
//

import SwiftUI

struct FrameworkDetailedView: View {
    
    var framework: Framework
    @Binding var isShowingDetailView: Bool
    
    var body: some View {
        VStack {
            
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
            
            Spacer()
            
            FrameworkTitleView(framework: framework)
            Text(framework.description)
                .font(.body)
                .padding()
            
            Spacer()
            
            Button {
                
            } label: {
                AFButton(title: "Learn More")
            }
        }
    }
}

#Preview {
    FrameworkDetailedView(framework: MockData.sampleFramework, isShowingDetailView: .constant(false))
}
