//
//  LineExtractor.swift
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

import SwiftUI

class LineExtractor: Converter {

  override init(name: String) {
    super.init(name: name)
  }

  override func run() {
    guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib") else {
      fatalError("Not found default.metallib.")
    }
    guard let data = try? Data(contentsOf: url) else {
      fatalError("The default.metallib can not read as Data.")
    }

    let image = UIImage(named: name)!
    let ciImage = CIImage(image: image)
    guard let grayscale = ciImage?.grayscale(metalLib: data),
          let dilated = grayscale.maxPooling(metalLib: data),
          let line = grayscale.difference(metalLib: data, dilated: dilated) else {
      fatalError("Can not convert grayscale or dilated image.")
    }
    if let cgImage = CIContext().createCGImage(line, from: line.extent) {
      converted = UIImage(cgImage: cgImage)
    }
  }
}
