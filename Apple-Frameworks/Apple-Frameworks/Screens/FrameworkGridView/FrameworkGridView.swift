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
    
    var body: some View {
        
        // New NavigationStack update iOS 16!!
        NavigationStack {
            // a "lazy" grid or stack is only rendered when used
            
            ScrollView {
                LazyVGrid(columns: viewModel.columns, content: {
                    
                    // you can use "ForEach" to iterate through an array to create all the views
                    
                    ForEach(MockData.frameworks, id: \.id) { framework in
                        // .\self means hash the object and give its unique ID, note that it must be Hashable
                        NavigationLink(value:framework) {
                            FrameworkTitleView(framework: framework)
                        }
                    }
                })
            }
            .navigationTitle("🍎 Frameworks")
            .navigationDestination(for: Framework.self) { framework in
                FrameworkDetailedView(framework: framework)
            }
            // the "sheet" is listening to the broadcast from ViewModel
            // $ means "binding"
            /*
            .sheet(isPresented: $viewModel.isShowingDetailView, content: {
                FrameworkDetailedView(framework: viewModel.selectedFramework ?? MockData.sampleFramework, isShowingDetailView: $viewModel.isShowingDetailView)
            }) */
        }
    }
}

#Preview {
    FrameworkGridView()
}
