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
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing], 8)
            HStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width)
                            .foregroundColor(.gray)
                            .opacity(0.3)
                        Rectangle()
                            .foregroundColor(model.timerViewColor)
                            .frame(width: min((CGFloat(model.progress) * geometry.size.width),
                                              geometry.size.width))
                    }
                    .clipShape(Capsule())
                    .frame(minWidth: min((CGFloat(model.progress) * geometry.size.width),
                           geometry.size.width - 40), maxWidth: .infinity, maxHeight: 10)
                    .padding([.leading, .top, .bottom], 16)
                }
                .animation(.linear(duration: 1.0), value: model.progress)
                Text("\(model.timeRemaining.parsedTimestamp)")
                    .frame(width: 40, height: 10, alignment: .leading)
                    .padding([.leading, .trailing, .top, .bottom], 8)
            }
        }
    }
}
