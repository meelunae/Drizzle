//
//  ProgressView.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Float
    @Binding var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(.gray)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0,
                    lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
        }
        .animation(.linear(duration: 1.0), value: progress)
    }
}

struct GaugeProgressView: View {
    @State var title: String
    @ObservedObject var model: PomodoroViewModel
    @State var buttonHovered: Bool = false
    var body: some View {
        VStack {
            Text(title)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 16)
            HStack(spacing: 10) {
                Spacer()
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(.secondary)
                            .opacity(0.3)
                            .frame(width: geometry.size.width - 20, height: 8)
                        Rectangle()
                            .fill(model.timerViewColor)
                            .frame(width: (geometry.size.width - 20) * CGFloat(model.progress), height: 8)
                    }
                    .clipShape(Capsule())
                }
                .animation(.linear(duration: 1), value: model.progress)
                Text("\(model.timeRemaining.parsedTimestamp)")
                    .font(.system(size: 12))
                    .monospaced()
                    .padding([.trailing], 8)
                Button(action: {
                    model.pomodoroState = .stopped
                }, label: {
                    Text("\(Image(systemName: "stop.circle"))")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(buttonHovered ? model.timerViewColor : .primary))
                         .onHover(perform: { _ in
                             buttonHovered.toggle()
                         })
                })
                .buttonStyle(.plain)
                .padding([.trailing], 16)
            }
            .frame(height: 8)
        }
        .padding(.bottom, 8)
    }
}
