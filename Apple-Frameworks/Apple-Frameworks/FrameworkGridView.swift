//
//  FrameworkGridView.swift
//  Apple-Frameworks
//
//  Created by Boyuan Jiang on 7/5/2024.
//

/// Declarative vs imperative: update data -> auto new UI
/// MVVM -- Model (e.g. struct Framework) <-> ViewModel (logic that dynamically changes data) <-> View (e.g. grid display)

import SwiftUI

struct FrameworkGridView: View {
    
    // recall that state objects will not get destroyed and recreated
    @StateObject var viewModel = FrameworkGridViewModel()
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack {
            // a "lazy" grid or stack is only rendered when used
            
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    
                    // you can use "ForEach" to iterate through an array to create all the views
                    
                    ForEach(MockData.frameworks, id: \.id) { framework in
                        FrameworkTitleView(framework: framework)
                        // think a bit if you don't get it
                        // .\self means hash the object and give its unique ID, note that it must be Hashable
                            .onTapGesture {
                                viewModel.selectedFramework = framework
                            }
                    }
                })
            }
            .navigationTitle("🍎 Frameworks")
            // the "sheet" is listening to the broadcast from ViewModel
            // $ means "binding"
            .sheet(isPresented: $viewModel.isShowingDetailView, content: {
                FrameworkDetailedView(framework: viewModel.selectedFramework ?? MockData.sampleFramework, isShowingDetailView: $viewModel.isShowingDetailView)
            }) // give content a default value; pass status from view model into detailed view
        }
    }
}

#Preview {
    FrameworkGridView()
}

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
