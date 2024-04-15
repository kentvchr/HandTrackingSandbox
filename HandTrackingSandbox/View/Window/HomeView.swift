//
//  HomeView.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(AppState.self) private var appState
    
    @State var showBackground: Bool = false
    
    var body: some View {
        VStack {
            pulsatingHandsView
            appHeaderView
            startHandTrackingButtonView
        }
        .frame(width: 800, height: 400)
        .background {
            if showBackground {
                Image("HomeBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.opacity)
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    showBackground = true
                }
            }
        }
    }
    
    var appHeaderView: some View {
        VStack {
            Text("Hand Tracking Sandbox")
                .font(.extraLargeTitle2)
                .fontWeight(.bold)
        }
    }
    
    var pulsatingHandsView: some View {
        HStack(spacing: -24) {
            Group {
                Image(systemName: "hand.raised.fill")
                    .foregroundStyle(.red)
                Image(systemName: "hand.raised.fill")
                    .foregroundStyle(.cyan)
                    .scaleEffect(x: -1, y: 1)
            }
            .font(.extraLargeTitle)
            .symbolEffect(.pulse)
        }
    }
    
    @MainActor
    var startHandTrackingButtonView: some View {
        Button("Start Immersion") {
            appState.phase = .immersion
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(AppState())
    }
}
