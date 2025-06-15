//
//  NavigationManager.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI
import Combine

@MainActor @Observable
class NavigationManager {
    var path = NavigationPath()
    
    func to(_ destination: AppDestination) {
        path.append(destination)
    }
    
    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func toRoot() {
        path = NavigationPath()
    }
    
    func toSpecific(_ destination: AppDestination) {
        while !path.isEmpty {
            path.removeLast()
        }
        path.append(destination)
    }
}
