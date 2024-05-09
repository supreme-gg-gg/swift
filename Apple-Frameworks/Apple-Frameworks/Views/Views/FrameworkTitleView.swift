//
//  SwiftUIView.swift
//  Apple-Frameworks
//
//  Created by Boyuan Jiang on 8/5/2024.
//

import SwiftUI

struct FrameworkTitleView: View {
    
    let framework: Framework
    
    var body: some View {
        VStack {
            Image(framework.imageName)
                .resizable()
                .frame(width: 90, height: 90)
            Text(framework.name)
                .font(.title2)
                .fontWeight(.semibold)
                .scaledToFit()
                .minimumScaleFactor(0.6)
        }
        .padding(15)
    }
    
}

#Preview {
    FrameworkTitleView(framework: MockData.sampleFramework)
}
