//
//  CIImage.swift
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

import CoreImage

extension CIImage {

  func grayscale(metalLib: Data) -> CIImage? {
    let name = "grayscale"
    guard let kernel = try? CIColorKernel(functionName: name, fromMetalLibraryData: metalLib) else {
      return self
    }
    let image = kernel.apply(extent: extent, roiCallback: { _, r in r }, arguments: [self])
    return image
  }

  func maxPooling(metalLib: Data) -> CIImage? {
    let name = "max_pooling"

    guard let kernel = try? CIKernel(functionName: name, fromMetalLibraryData: metalLib) else {
      return self
    }

    let image = kernel.apply(extent: extent, roiCallback: { _, r in r }, arguments: [self])
    return image
  }

  func difference(metalLib: Data, dilated: CIImage) -> CIImage? {
    let name = "difference"
    guard let kernel = try? CIKernel(functionName: name, fromMetalLibraryData: metalLib) else {
      return self
    }

    let image = kernel.apply(extent: extent, roiCallback: { _, r in r }, arguments: [self, dilated])
    return image
  }
}
