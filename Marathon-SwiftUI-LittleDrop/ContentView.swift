//
//  ContentView.swift
//  Marathon-SwiftUI-LittleDrop
//
//  Created by Sergey Leontiev on 23.12.24..
//

import SwiftUI

struct ContentView: View {
    @State var dragOffset = CGSize.zero
    
    var body: some View {
        VStack {
            ZStack {
                Color.red
                Color.yellow
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
                    .blur(radius: 15)
                Image(systemName: "cloud.sun.rain.fill")
                    .symbolRenderingMode(.hierarchical)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .offset(dragOffset)
            }
            .mask {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                    context.addFilter(.blur(radius: 30))
                    
                    context.drawLayer { ctx in
                        for index in [1,2] {
                            guard let resolvedView = context.resolveSymbol(id: index) else { break }
                            ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                        }
                    }
                } symbols: {
                    Circle()
                        .frame(width: 150, height: 150)
                        .tag(1)
                        .offset(dragOffset)
                    
                    Circle()
                        .frame(width: 150, height: 150)
                        .tag(2)
                }
            }
            .background(.black)
            .gesture(DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                } .onEnded { _ in
                    withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                        dragOffset = .zero
                    }
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
