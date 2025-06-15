//
//  ChatListView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct ChatListView: View {
    @Environment(NavigationManager.self) var navigate
    @State var scrollOffset: CGFloat = 0
    @State private var searchText = ""
    
    // User type - this should be passed from ContentView or managed globally
    @AppStorage("isNGO") private var isNGO = false
    @AppStorage("isRestaurant") private var isRestaurant = false
    
    // Mock data - replace with your actual data models
    @State private var restaurants: [ChatContact] = [
        ChatContact(id: "1", name: "Mario's Pizza Palace", type: .restaurant, lastMessage: "We have fresh pizza available!", timestamp: Date().addingTimeInterval(-3600), isOnline: true),
        ChatContact(id: "2", name: "Green Garden Bistro", type: .restaurant, lastMessage: "Organic salads ready for pickup", timestamp: Date().addingTimeInterval(-7200), isOnline: false),
        ChatContact(id: "3", name: "Spice Route Kitchen", type: .restaurant, lastMessage: "Special curry available today", timestamp: Date().addingTimeInterval(-10800), isOnline: true),
        ChatContact(id: "4", name: "Foundation AI Assistant", type: .ai, lastMessage: "How can I help you today?", timestamp: Date().addingTimeInterval(-300), isOnline: true)
    ]
    
    @State private var ngos: [ChatContact] = [
        ChatContact(id: "5", name: "Hope Food Bank", type: .ngo, lastMessage: "Thank you for your donation!", timestamp: Date().addingTimeInterval(-1800), isOnline: true),
        ChatContact(id: "6", name: "Community Care Center", type: .ngo, lastMessage: "We need more volunteers", timestamp: Date().addingTimeInterval(-5400), isOnline: false),
        ChatContact(id: "7", name: "Helping Hands NGO", type: .ngo, lastMessage: "Food distribution tomorrow", timestamp: Date().addingTimeInterval(-9000), isOnline: true),
        ChatContact(id: "8", name: "Foundation AI Assistant", type: .ai, lastMessage: "Ready to assist with your queries!", timestamp: Date().addingTimeInterval(-300), isOnline: true)
    ]
    
    var filteredContacts: [ChatContact] {
        let contacts = isNGO ? restaurants : ngos
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea(edges: .all)
            
            NavigationBarView(title: "Messages", scrollOffset: $scrollOffset) {
                content
            }
        }
    }
    
    var content: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchBar
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            // Chat List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredContacts) { contact in
                            ChatContactRow(contact: contact) {
                                if contact.type == .ai {
                                    // Navigate to Foundation Models chat
                                    navigate.to(.chat(participantId: "foundation-ai"))
                                } else {
                                    navigate.to(.chat(participantId: contact.id))
                                }
                            }
                        }
                        
                        // Empty state
                        if filteredContacts.isEmpty {
                            EmptyChatsView(isNGO: isNGO)
                                .padding(.top, 60)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ViewOffsetKey.self,
                            value: -geometry.frame(in: .named("scrollView")).origin.y
                        )
                    }
                )
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    scrollOffset = value
                }
                .coordinateSpace(name: "scrollView")
            }
            
            Spacer()
        }
    }
    
    var searchBar: some View {
        ZStack {
            // Shadow
            RoundedRectangle(cornerRadius: 16)
                .fill(.black)
                .frame(height: 50)
                .offset(x: 3, y: 3)
            
            // Main search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black.opacity(0.6))
                
                TextField("Search messages...", text: $searchText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 3)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct ChatContact: Identifiable {
    let id: String
    let name: String
    let type: ContactType
    let lastMessage: String
    let timestamp: Date
    let isOnline: Bool
    
    enum ContactType {
        case restaurant, ngo, ai
    }
}

struct ChatContactRow: View {
    let contact: ChatContact
    let onTap: () -> Void
    
    private var contactColor: Color {
        switch contact.type {
        case .restaurant:
            return .atomicTangerine
        case .ngo:
            return .pistachio
        case .ai:
            return .steelBlue
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        let now = Date()
        let timeInterval = now.timeIntervalSince(contact.timestamp)
        
        if timeInterval < 60 {
            return "now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)m"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)h"
        } else {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: contact.timestamp)
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Shadow
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black)
                    .frame(height: 80)
                    .offset(x: 4, y: 4)
                
                // Main card
                HStack(spacing: 16) {
                    // Avatar
                    ZStack {
                        // Avatar shadow
                        Circle()
                            .fill(.black)
                            .frame(width: 56, height: 56)
                            .offset(x: 2, y: 2)
                        
                        Circle()
                            .fill(contactColor)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 3)
                            )
                            .overlay(
                                Group {
                                    switch contact.type {
                                    case .restaurant:
                                        Image(systemName: "fork.knife")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.black)
                                    case .ngo:
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.black)
                                    case .ai:
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                }
                            )
                        
                        // Online indicator
                        if contact.isOnline {
                            Circle()
                                .fill(.pistachio)
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 2)
                                )
                                .offset(x: 20, y: -20)
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(contact.name)
                                .font(.system(size: 18, weight: .bold))
                                .fontWidth(.expanded)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(timeString)
                                .font(.system(size: 12, weight: .bold))
                                .fontWidth(.expanded)
                                .foregroundColor(.black.opacity(0.6))
                        }
                        
                        Text(contact.lastMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(height: 80)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyChatsView: View {
    let isNGO: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Shadow
                Circle()
                    .fill(.black)
                    .frame(width: 80, height: 80)
                    .offset(x: 3, y: 3)
                
                Circle()
                    .fill(.persianRed)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(.black, lineWidth: 3)
                    )
                    .overlay(
                        Image(systemName: "message.fill")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                    )
            }
            
            VStack(spacing: 8) {
                Text("No Messages Yet")
                    .font(.system(size: 24, weight: .bold))
                    .fontWidth(.expanded)
                    .foregroundColor(.black)
                
                Text(isNGO ? "Start chatting with restaurants to coordinate food donations!" : "Connect with NGOs to share your surplus food!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}
