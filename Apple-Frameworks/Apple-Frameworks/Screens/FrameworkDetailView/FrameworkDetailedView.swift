//
//  FrameworkDetailedView.swift
//  Apple-Frameworks
//
//  Created by Boyuan Jiang on 7/5/2024.
//

import SwiftUI

struct FrameworkDetailedView: View {
    
    var framework: Framework
    @Binding var isShowingDetailView: Bool // binding, unlike stage, works across struct & files
    @State private var isShowingSafariView = false
    
    var body: some View {
        VStack {
            
            XDismissButton(isShowingDetailView: $isShowingDetailView)
            
            Spacer()
            
            FrameworkTitleView(framework: framework)
            Text(framework.description)
                .font(.body)
                .padding()
            
            Spacer()
            
            Button {
                isShowingSafariView = true
            } label: {
                AFButton(title: "Learn More")
            }
        }
        .sheet(isPresented: $isShowingSafariView, content: {
            SafariView(url: (URL(string: framework.urlString) ?? URL(string:"www.apple.com")!))
        }) // if you want a full page on top use "fullScreenCover" instead of "sheet"
    }
}

#Preview {
    FrameworkDetailedView(framework: MockData.sampleFramework, isShowingDetailView: .constant(false))
}
