//
//  UserTypeSelectionView.swift
//  MealBridge
//
//  Created by Aarav Gupta on 12/06/25.
//

import SwiftUI

struct UserTypeSelectionView: View {
    @Binding var isNGO: Bool
    @Binding var isRestraunt: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text("How would you like to contribute?")
                .foregroundStyle(.black)
                .fontWeight(.semibold)
                .fontWidth(.expanded)
            
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .offset(x: 2, y: 2)
                    
                    Group {
                        ZStack {
                            Rectangle()
                                .fill(.atomicTangerine)
                                .border(.black, width: 1)
                            
                            if isNGO {
                                Rectangle()
                                    .fill(.black.opacity(0.2))
                            }
                        }
                        
                        Text("Distribute")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                    }
                    .offset(x: isNGO ? 2 : -2, y: isNGO ? 2 : -2)
                    .animation(.snappy, value: isNGO)
                }
                .frame(height: 48)
                .onTapGesture {
                    if isRestraunt {
                        isRestraunt = false
                        isNGO = true
                    } else {
                        isNGO.toggle()
                    }
                }
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .offset(x: 2, y: 2)
                    
                    Group {
                        ZStack {
                            Rectangle()
                                .fill(.steelBlue)
                                .border(.black, width: 1)
                            
                            if isRestraunt {
                                Rectangle()
                                    .fill(.black.opacity(0.2))
                            }
                        }
                        
                        Text("Donate")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .fontWidth(.expanded)
                    }
                    .offset(x: isRestraunt ? 2 : -2, y: isRestraunt ? 2 : -2)
                    .animation(.snappy, value: isRestraunt)
                }
                .frame(height: 48)
                .onTapGesture {
                    if isNGO {
                        isNGO = false
                        isRestraunt = true
                    } else {
                        isRestraunt.toggle()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    UserTypeSelectionView(isNGO: .constant(false), isRestraunt: .constant(false))
}
