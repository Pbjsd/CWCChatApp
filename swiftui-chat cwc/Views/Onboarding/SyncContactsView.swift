//
//  SyncContactsView.swift
//  swiftui-chat cwc
//
//  Created by Panchi on 7/21/22.
//

import SwiftUI

struct SyncContactsView: View {
    
    @Binding var isOnboarding: Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("onboarding-all-set")
            
            Text("Awesome!")
                .font(Font.titleText)
                .padding(.top, 32)
            
            Text("Continue to start chatting with your friends.")
                .font(Font.bodyParagraph)
                .padding(.top, 8)
            
            
            Spacer()
            
            Button {
                // End onboarding
                isOnboarding = false
               
            } label: {
                
                Text("Continue")
                
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
            
            
        }
        .padding(.horizontal)

    }
}

struct SyncContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SyncContactsView(isOnboarding: .constant(true))
    }
}
