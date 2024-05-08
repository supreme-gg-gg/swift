//
//  FrameworkGridViewModel.swift
//  Apple-Frameworks
//
//  Created by Boyuan Jiang on 7/5/2024.
//

import SwiftUI

/// use a class to hold state
/// This protocol allows the class to broadcast info if it changes
/// If not subclassing a class call it "final"
final class FrameworkGridViewModel: ObservableObject {
    var selectedFramework: Framework? { // note that it is optional
        didSet { // any time selectedFramework changes...
            isShowingDetailView = true
        }
    }
    
    @Published var isShowingDetailView = false // this needs to be published for view to update
    
    
}
