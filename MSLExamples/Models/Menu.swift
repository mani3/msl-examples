//
//  Menu.swift
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

import Foundation

class MenuList: ObservableObject {
  @Published var menus = [Menu]()

  init() {
    self.menus = [
      Menu(
        title: "Original Image",
        imageName: "Images/lena.png",
        converter: Converter(name: "Images/lena.png")
      ),
      Menu(
        title: "Grayscale",
        imageName: "Images/lena.png",
        converter: Grayscale(name: "Images/lena.png")
      ),
      Menu(
        title: "Line Drawing",
        imageName: "Images/lena.png",
        converter: LineExtractor(name: "Images/lena.png")
      )
    ]
  }
}

struct Menu: Identifiable {
  var id = UUID()
  var title: String
  var imageName: String
  var converter: Converter
}
