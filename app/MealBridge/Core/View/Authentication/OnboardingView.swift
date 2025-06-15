//
//  OnboardingView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding = true
    @Binding var isNGO: Bool
    @Binding var isRestraunt: Bool
    
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                Spacer()
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("Welcome to")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("MealBridge")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(.black)
                        .fontWidth(.expanded)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Bridging the Gap Between")
                            Text("Surplus and Scarcity.")
                        }
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black.opacity(0.8))
                    }
                    .padding(.top, -128)
                    .padding(.bottom, 64)
                    
                    Spacer()
                }
                .padding()
                
                UserTypeSelectionView(isNGO: $isNGO, isRestraunt: $isRestraunt)
                
                Spacer()
                
                Button {
                    isOnboarding = false
                } label: {
                    ZStack {
                        Circle()
                            .fill(.black)
                            .offset(x: 2, y: 2)
                        
                        Circle()
                            .fill(!isNGO && !isRestraunt ? .gray :  Color.pistachio)
                            .stroke(.black, lineWidth: 1)

                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                    }
                    .frame(width: 50)
                }
                .disabled(!isNGO && !isRestraunt)
                
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingView(isNGO: .constant(false), isRestraunt: .constant(false))
}
