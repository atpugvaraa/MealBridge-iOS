//
//  ChatView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct ChatView: View {
    let participantId: String
    @Environment(NavigationManager.self) var navigate
    @Environment(\.dismiss) private var dismiss
    
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @State private var isTyping = false
    @State private var scrollOffset: CGFloat = 0
    
    // Foundation Models integration (placeholder for now)
    @State private var isAIChat = false
    @State private var isProcessingAI = false
    
    var participantName: String {
        if participantId == "foundation-ai" {
            return "AI Assistant"
        }
        // Replace with actual participant name lookup
        return "Chat Partner"
    }
    
    var participantType: ChatContact.ContactType {
        if participantId == "foundation-ai" {
            return .ai
        }
        // Replace with actual type lookup
        return .restaurant
    }
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header
                chatHeader
                
                // Messages area
                messagesArea
                
                // Input area
                messageInputArea
            }
        }
        .onAppear {
            isAIChat = participantId == "foundation-ai"
            loadInitialMessages()
        }
        .navigationBarHidden(true)
    }
    
    var chatHeader: some View {
        ZStack {
            // Shadow
            Rectangle()
                .fill(.black)
                .frame(height: 80)
                .offset(y: 3)
            
            HStack {
                // Back button
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 40, height: 40)
                            .offset(x: 2, y: 2)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                            )
                    }
                }
                
                // Participant info
                HStack(spacing: 12) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 44, height: 44)
                            .offset(x: 2, y: 2)
                        
                        Circle()
                            .fill(participantColor)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                            .overlay(
                                participantIcon
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(participantName)
                            .font(.system(size: 18, weight: .bold))
                            .fontWidth(.expanded)
                            .foregroundColor(.black)
                        
                        Text(isAIChat ? "AI Assistant" : "Online")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // More options button
                Button {
                    // Add more options
                } label: {
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 40, height: 40)
                            .offset(x: 2, y: 2)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                            .overlay(
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .background(.white)
            .overlay(
                Rectangle()
                    .stroke(.black, lineWidth: 3)
            )
        }
    }
    
    var messagesArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    Spacer(minLength: 20)
                    
                    ForEach(messages) { message in
                        MessageBubble(message: message, isAIChat: isAIChat)
                            .id(message.id)
                    }
                    
                    // Typing indicator
                    if isTyping || isProcessingAI {
                        TypingIndicator(isAI: isAIChat)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
            .onChange(of: messages.count) { _, _ in
                if let lastMessage = messages.last {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    var messageInputArea: some View {
        ZStack {
            // Shadow
            Rectangle()
                .fill(.black)
                .frame(height: 80)
                .offset(y: -3)
            
            HStack(spacing: 12) {
                // Message input
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .frame(height: 50)
                        .offset(x: 2, y: 2)
                    
                    HStack {
                        TextField("Type a message...", text: $messageText, axis: .vertical)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .lineLimit(1...4)
                        
                        if !messageText.isEmpty {
                            Button {
                                sendMessage()
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.steelBlue)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(minHeight: 50)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black, lineWidth: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .background(.white)
            .overlay(
                Rectangle()
                    .stroke(.black, lineWidth: 3)
            )
        }
    }
    
    private var participantColor: Color {
        switch participantType {
        case .restaurant:
            return .atomicTangerine
        case .ngo:
            return .pistachio
        case .ai:
            return .steelBlue
        }
    }
    
    private var participantIcon: some View {
        Group {
            switch participantType {
            case .restaurant:
                Image(systemName: "fork.knife")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            case .ngo:
                Image(systemName: "heart.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            case .ai:
                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            }
        }
    }
    
    private func loadInitialMessages() {
        // Mock initial messages
        if isAIChat {
            messages = [
                ChatMessage(
                    id: UUID().uuidString,
                    text: "Hello! I'm your AI assistant powered by Foundation Models. I can help you with food donation coordination, menu suggestions, and answer questions about your app. How can I assist you today?",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-300),
                    isAI: true
                )
            ]
        } else {
            messages = [
                ChatMessage(
                    id: UUID().uuidString,
                    text: "Hi! Thanks for connecting with us.",
                    isFromUser: false,
                    timestamp: Date().addingTimeInterval(-300),
                    isAI: false
                )
            ]
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID().uuidString,
            text: messageText,
            isFromUser: true,
            timestamp: Date(),
            isAI: false
        )
        
        messages.append(userMessage)
        let sentText = messageText
        messageText = ""
        
        if isAIChat {
            handleAIResponse(for: sentText)
        } else {
            // Handle regular chat
            simulateResponse(for: sentText)
        }
    }
    
    private func handleAIResponse(for text: String) {
        isProcessingAI = true
        
        // Simulate AI processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessingAI = false
            
            // This is where you'd integrate with Foundation Models
            let aiResponse = generateAIResponse(for: text)
            
            let aiMessage = ChatMessage(
                id: UUID().uuidString,
                text: aiResponse,
                isFromUser: false,
                timestamp: Date(),
                isAI: true
            )
            
            messages.append(aiMessage)
        }
    }
    
    private func generateAIResponse(for text: String) -> String {
        // Placeholder AI responses - replace with Foundation Models integration
        let responses = [
            "I understand you're asking about \"\(text)\". As an AI assistant, I can help you with food donation coordination, menu planning, and connecting with local organizations.",
            "Based on your query about \"\(text)\", I'd recommend checking our food listings section or reaching out to nearby NGOs for assistance.",
            "That's a great question about \"\(text)\". Let me help you find the best approach for your food donation needs.",
            "I can see you're interested in \"\(text)\". Would you like me to suggest some restaurants or NGOs in your area that might be able to help?"
        ]
        
        return responses.randomElement() ?? "I'm here to help! Could you provide more details about what you need assistance with?"
    }
    
    private func simulateResponse(for text: String) {
        isTyping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isTyping = false
            
            let response = ChatMessage(
                id: UUID().uuidString,
                text: "Thanks for your message! We'll get back to you soon.",
                isFromUser: false,
                timestamp: Date(),
                isAI: false
            )
            
            messages.append(response)
        }
    }
}

struct ChatMessage: Identifiable {
    let id: String
    let text: String
    let isFromUser: Bool
    let timestamp: Date
    let isAI: Bool
}

struct MessageBubble: View {
    let message: ChatMessage
    let isAIChat: Bool
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            ZStack {
                // Shadow
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black)
                    .offset(x: message.isFromUser ? -2 : 2, y: 2)
                
                // Message bubble
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Spacer()
                        Text(formatTime(message.timestamp))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(bubbleColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isFromUser ? .trailing : .leading)
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
    
    private var bubbleColor: Color {
        if message.isFromUser {
            return .steelBlue
        } else if message.isAI {
            return .pistachio
        } else {
            return .white
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TypingIndicator: View {
    let isAI: Bool
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            ZStack {
                // Shadow
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black)
                    .offset(x: 2, y: 2)
                
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(.black.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .offset(y: animationOffset)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: animationOffset
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isAI ? .pistachio : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Spacer()
        }
        .onAppear {
            animationOffset = -4
        }
    }
}
