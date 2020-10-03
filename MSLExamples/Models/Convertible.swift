//
//  Convertible.swift
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

import UIKit
import Combine

protocol Convertible {
  var imagePublisher: Published<UIImage>.Publisher { get }
  func run()
}

class Converter: ObservableObject, Convertible {
  @Published var converted = UIImage()
  var imagePublisher: Published<UIImage>.Publisher { $converted }

  let name: String

  init(name: String) {
    self.name = name
  }

  func run() {
    self.converted = UIImage(named: name) ?? UIImage()
    print(converted)
  }
}

class Grayscale: Converter {
  private var dispose = Set<AnyCancellable>()

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
    guard let grayscale = ciImage?.grayscale(metalLib: data) else {
      fatalError("Can not convert grayscale or dilated image.")
    }
    if let cgImage = CIContext().createCGImage(grayscale, from: grayscale.extent) {
      converted = UIImage(cgImage: cgImage)
    }
  }
}

enum ImageUtil {
  static func path(name: String = "photos") -> URL {
    let manager = FileManager.default
    let document = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    let photoDirectoryPath = document?.appendingPathComponent(name)

    guard let path = photoDirectoryPath else {
      fatalError("Not get document directory path")
    }
    if !manager.fileExists(atPath: path.path) {
      do {
        try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
      } catch {
        NSLog("%@, %@", #function, error.localizedDescription)
      }
    }
    return path
  }
}
