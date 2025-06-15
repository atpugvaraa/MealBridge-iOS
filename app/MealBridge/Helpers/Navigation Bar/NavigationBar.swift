//
//  NavigationBar.swift
//  cisum
//
//  Created by Aarav Gupta (github.com/atpugvaraa) on 18/03/25.
//

import SwiftUI

struct NavigationBar: View {
    @Environment(\.navigationBarStyle) private var config
    @Environment(\.dismiss) private var dismiss
    
    var scrollOffset: CGFloat
    var title: String
    var icon: String?
    @State var showTopRightButton: Bool
    @State var showBackButton: Bool
    
    init(scrollOffset: CGFloat, title: String, icon: String? = nil, showTopRightButton: Bool = false, showBackButton: Bool = false) {
        self.scrollOffset = scrollOffset
        self.title = title
        self.icon = icon
        self.showTopRightButton = showTopRightButton
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .frame(height: interpolation(start: 200, end: 130, transitionOffset: 60))
                .edgesIgnoringSafeArea(.top)
            
            navigationBar
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    var navigationBar: some View {
        VStack {
            navigationTitle
            
//            if config.showSearchBar {
//                searchBar
//
//                if search.isSearching {
//                    searchChips
//                }
//            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.3), value: scrollOffset)
        .offset(y: interpolation(start: config.showSearchBar ? -12 : -30, end: config.showSearchBar ? -21 : -40, transitionOffset: 60))
    }
    
    var navigationTitle: some View {
        HStack {
            if showBackButton {
                backButton
            }
            
            Text(title)
                .foregroundStyle(.black)
                .font(.system(size: interpolation(start: showBackButton ? 25 : 35, end: showBackButton ? 20 : 30, transitionOffset: 60)))
                .fontWeight(.bold)
                .fontWidth(.expanded)
            
            Spacer()
            
            if showTopRightButton {
                topRightButton()
            }
        }
        .padding()
    }
    
//    var searchBar: some View {
//        cisumSearchViewController(text: $search.keyword, isSearching: $search.isSearching)
//            .frame(height: 44)
//            .padding(.horizontal, 8)
//            .padding(.top, -16)
//            .transition(.move(edge: .top).combined(with: .opacity))
//    }
    
//    var searchChips: some View {
//        cisumSearchChips()
//    }

    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .offset(x: 1, y: 1)
                
                Circle()
                    .fill(Color.offWhite)
                    .stroke(.black, lineWidth: 2)
                    .offset(x: -1, y: -1)
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                    .offset(x: -1, y: -1)
            }
            .frame(height: interpolation(start: 35, end: 30, transitionOffset: 60))
        }
        .padding(.trailing, 12)
    }
    
    @ViewBuilder func topRightButton() -> some View {
        NavigationLink {
            ProfileView()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .offset(x: 1, y: 1)
                
                Circle()
                    .fill(Color.offWhite)
                    .stroke(.black, lineWidth: 2)
                    .offset(x: -1, y: -1)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                        .offset(x: -1, y: -1)
                        .scaleEffect(interpolation(start: 1.0, end: 0.857, transitionOffset: 60))
                }
            }
            .frame(height: interpolation(start: 35, end: 30, transitionOffset: 60))
        }
    }
    
    private func interpolation(start: CGFloat, end: CGFloat, transitionOffset: CGFloat) -> CGFloat {
        let progress = min(max(scrollOffset / transitionOffset , 0), 1)
        return end + (start - end) * progress
    }
}

extension EnvironmentValues {
    var navigationBarStyle: NavigationBarStyle {
        get { self[NavigationBarStyleKey.self] }
        set { self[NavigationBarStyleKey.self] = newValue }
    }
}
