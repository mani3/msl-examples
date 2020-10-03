//
//  PictureView.swift
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

import SwiftUI

struct PictureView: View {

  @ObservedObject var converter: Converter
  @State private var scale = CGFloat(1.0)
  @State private var latestScale = CGFloat(1.0)
  @State private var tappedPoint = CGPoint.zero
  @State private var draggedSize = CGSize.zero
  @State private var previousDragged = CGSize.zero

  init(converter: Converter) {
    self.converter = converter
  }

  var pinch: some Gesture {
    MagnificationGesture()
      .onChanged { scale in
        self.scale = self.latestScale * scale
      }.onEnded { scale in
        self.latestScale = self.scale
      }
  }

  var body: some View {
    ZStack {
      GeometryReader { geometry in
        Image(uiImage: self.converter.converted)
          .resizable()
          .scaledToFit()
          .animation(.easeInOut)
          .offset(self.draggedSize)
          .scaleEffect(self.scale)
          .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
              .onChanged { value in
                self.tappedPoint = value.startLocation
                self.draggedSize = CGSize(
                  width: value.translation.width + self.previousDragged.width,
                  height: value.translation.height + self.previousDragged.height)
            }
            .onEnded { _ in
              let offset = CGSize(
                width: geometry.frame(in: .global).maxX * (max(self.scale, 1.0) - 1.0) / 2,
                height: geometry.frame(in: .global).maxY * (max(self.scale, 1.0) - 1.0) / 2)

              let w = max(min(self.draggedSize.width, offset.width), -offset.width) / self.scale
              let h = max(min(self.draggedSize.height, offset.height), -offset.height) / self.scale
              self.draggedSize = CGSize(width: w, height: h)
              self.previousDragged = self.draggedSize
          })
          .gesture(self.pinch)
      }
    }
    .navigationTitle(self.converter.name)
    .accentColor(Color.black)
    .background(Color.black)
    .onAppear(perform: { self.converter.run() })
  }
}

struct PictureView_Previews: PreviewProvider {
  static var previews: some View {
    PictureView(converter: Converter(name: "Images/lena.png"))
  }
}
