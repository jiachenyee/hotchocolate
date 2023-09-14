//
//  OnboardingRow.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import SwiftUI

struct OnboardingRow<Content: View>: View {
    
    var state: OnboardingState
    @Binding var currentState: OnboardingState
    
    var systemImage: String
    var title: String
    var description: String
    
    let content: Content
    
    var isNextButtonHidden = false
    
    @Namespace var namespace
    
    init(state: OnboardingState, currentState: Binding<OnboardingState>,
         systemImage: String,
         title: String,
         description: String,
         isNextButtonHidden: Bool = false,
         @ViewBuilder content: @escaping (() -> Content)) {
        self.state = state
        self._currentState = currentState
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.isNextButtonHidden = isNextButtonHidden
        self.content = content()
    }
    
    init(state: OnboardingState,
         currentState: Binding<OnboardingState>,
         systemImage: String,
         title: String,
         description: String, 
         isNextButtonHidden: Bool = false) where Content == EmptyView {
        self.state = state
        self._currentState = currentState
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.isNextButtonHidden = isNextButtonHidden
        self.content = EmptyView()
    }
    
    var body: some View {
        if state == currentState {
            HStack(alignment: .top) {
                Image(systemName: systemImage)
                    .font(.title)
                    .frame(width: 48)
                    .matchedGeometryEffect(id: "\(state.rawValue)icon", in: namespace)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .matchedGeometryEffect(id: "\(state.rawValue)title", in: namespace)
                    
                    Text(description)
                        .padding(.top, 1)
                    
                    content
                        .padding(.vertical)
                    
                    if !isNextButtonHidden {
                        Button("Next") {
                            withAnimation {
                                currentState.next()
                            }
                        }
                        .matchedGeometryEffect(id: "nextButton", in: namespace)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 2)
            }
            .matchedGeometryEffect(id: "\(state.rawValue)frame", in: namespace)
            .padding(.horizontal)
        } else {
            Button {
                withAnimation {
                    currentState = state
                }
            } label: {
                HStack(alignment: .top) {
                    Image(systemName: systemImage)
                        .font(.title3)
                        .frame(width: 48)
                        .matchedGeometryEffect(id: "\(state.rawValue)icon", in: namespace)
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .matchedGeometryEffect(id: "\(state.rawValue)title", in: namespace)
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .matchedGeometryEffect(id: "\(state.rawValue)frame", in: namespace)
            .padding(.horizontal)
        }
    }
}
