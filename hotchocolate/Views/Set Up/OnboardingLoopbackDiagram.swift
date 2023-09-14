//
//  OnboardingLoopbackDiagram.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import SwiftUI

struct OnboardingLoopbackDiagram: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Sources")
                    .font(.headline)
                Label("Krisp", systemImage: "mic")
                    .frame(height: 16)
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                
                Label("Capture Card Audio", systemImage: "appletv")
                    .frame(height: 16)
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(width: geometry.size.width / 5, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text("Output Channels")
                    .font(.headline)
                Label("Channel 1 (L)", systemImage: "airpodpro.left")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Label("Channel 2 (R)", systemImage: "airpodpro.right")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Label("Capture Card Audio", systemImage: "appletv")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(width: geometry.size.width / 5, alignment: .leading)
            .offset(x: geometry.size.width / 5 * 2)
            
            VStack(alignment: .leading) {
                Text("Output Channels")
                    .font(.headline)
                
                Label("Channel 1 (L)", systemImage: "airpodpro.left")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Label("Channel 2 (R)", systemImage: "airpodpro.right")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Label("Channel 3", systemImage: "3.circle")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Label("Channel 4", systemImage: "4.circle")
                    .padding()
                    .frame(width: geometry.size.width / 5, alignment: .leading)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
            }
            .frame(width: geometry.size.width / 5, alignment: .leading)
            .offset(x: geometry.size.width / 5 * 2)
            
            VStack(alignment: .leading) {
                Text("Monitors")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    Label("Crestron 420", systemImage: "speaker.wave.2.fill")
                        .font(.headline)
                    
                    Divider()
                    
                    Label("Channel 1 (L)", systemImage: "airpodpro.left")
                        .padding(.top, 8)
                        .padding(.bottom)
                    Label("Channel 2 (R)", systemImage: "airpodpro.right")
                }
                .padding()
                .frame(width: geometry.size.width / 5, alignment: .leading)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(width: geometry.size.width / 5, alignment: .leading)
            .offset(x: geometry.size.width / 5 * 4)
            
            Group {
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5, y: 16 + 24 + 4 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 2, y: 16 + 24 + 4 + 5))
                }
                .stroke(.red, lineWidth: 3)
                .shadow(color: .black, radius: 8, x: 0, y: 0)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5, y: 16 + 24 + 4 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 2, y: 16 + 48 + 24 + 10 + 5))
                }
                .stroke(.orange, lineWidth: 3)
                .shadow(color: .black, radius: 8, x: 0, y: 0)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5, y: 16 + 48 + 24 + 10 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 2, y: 16 + 24 + 4 + 5))
                }
                .stroke(.cyan, lineWidth: 3)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5, y: 16 + 48 + 24 + 10 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 2, y: 16 + 48 + 24 + 10 + 5))
                }
                .stroke(.blue, lineWidth: 3)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5, y: 16 + 48 + 24 + 10 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 2, y: 16 + 48 + 48 + 48 + 24 + 26 + 5))
                }
                .stroke(.indigo, lineWidth: 3)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5, y: 16 + 48 + 24 + 10 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 2, y: 16 + 48 + 48 + 24 + 18 + 5))
                }
                .stroke(.purple, lineWidth: 3)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5 * 3, y: 16 + 48 + 48 + 48 + 24 + 26 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 4 - 5, y: 16 + 48 + 48 + 8 + 5))
                }
                .stroke(.green, lineWidth: 3)
                
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width / 5 * 3, y: 16 + 48 + 48 + 24 + 18 + 5))
                    path.addLine(to: CGPoint(x: geometry.size.width / 5 * 4 - 5, y: 16 + 48 + 20 + 5))
                }
                .stroke(.teal, lineWidth: 3)
            }
            .shadow(color: .black, radius: 4, x: 0, y: 0)
            
            Group {
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 - 5, y: 16 + 24 + 4)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 - 5, y: 16 + 48 + 24 + 10)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 2 - 5, y: 16 + 24 + 4)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 2 - 5, y: 16 + 48 + 24 + 10)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 2 - 5, y: 16 + 48 + 48 + 24 + 18)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 2 - 5, y: 16 + 48 + 48 + 48 + 24 + 26)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 3 - 5, y: 16 + 48 + 48 + 24 + 18)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 3 - 5, y: 16 + 48 + 48 + 48 + 24 + 26)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 4 - 5, y: 16 + 48 + 20)
                
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width / 5 * 4 - 5, y: 16 + 48 + 48 + 8)
            }
            
        }
    }
}

#Preview {
    OnboardingLoopbackDiagram()
}
