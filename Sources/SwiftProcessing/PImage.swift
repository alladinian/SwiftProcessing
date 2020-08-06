//
//  PImage.swift
//  
//
//  Created by Vasilis Akoinoglou on 6/8/20.
//

import Foundation
import CoreGraphics

#if os(iOS)
import UIKit
public typealias PImage = UIImageView
public typealias Image = UIImage
#endif

#if os(macOS)
import AppKit
public typealias PImage = NSImageView
public typealias Image = NSImage
#endif


public func loadImage(_ name: String, _ ext: String? = nil) -> PImage? {
    let url = URL(fileURLWithPath: [name, ext].compactMap { $0 }.joined(separator: "."))
    #if os(macOS)
    guard let image = Image(contentsOf: url) else { return nil }
    #endif
    #if os(iOS)
    guard let image = Image(contentsOfFile: url.path) else { return nil }
    #endif
    let view = PImage(image: image)
    view.bounds.size = image.size
    view.sizeToFit()
    return view
}

/**
THRESHOLD
GRAY
OPAQUE
INVERT
POSTERIZE
BLUR
ERODE
DILATE
 */

public enum PImageFilter {
    case threshold, gray, opaque, invert, posterize, blur, erode, dilate

    var filter: CIFilter? {
        switch self {
        case .gray:      return CIFilter(name: "CIPhotoEffectTonal")!
        case .invert:    return CIFilter(name: "CIColorInvert")!
        case .posterize: return CIFilter(name: "CIColorPosterize")!
        case .blur:      return CIFilter(name: "CIGaussianBlur")!
        case .threshold: return ThresholdFilter()
        case .opaque:    return OpaqueFilter()
        default:
            print("Filter not implemented yet")
            return nil
        }
    }
}

#if os(macOS)
extension NSImage {
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: [:])
    }
}
#endif

public extension PImage {

    var width: CGFloat {
        bounds.width
    }

    var height: CGFloat {
        bounds.height
    }

    func filter(_ kind: PImageFilter, _ param: CGFloat? = nil) {
        guard let image = image?.cgImage else { return }
        let input = CIImage(cgImage: image)
        guard let filter = kind.filter else { return }

        filter.setValue(input, forKey: kCIInputImageKey)

        if let param = param {
            switch kind {
            case .threshold:
                filter.setValue(param, forKey: "inputThreshold")
            case .gray:
                break
            case .opaque:
                break
            case .invert:
                break
            case .posterize:
                filter.setValue(param, forKey: "inputLevels")
            case .blur:
                filter.setValue(param, forKey: kCIInputRadiusKey)
            case .erode:
                break
            case .dilate:
                break
            }
        }

        #if os(macOS)
        contentFilters.append(filter)
        #endif

        #if os(iOS)
        guard let output = filter.outputImage else { return }
        let context = CIContext()
        guard let cgimg = context.createCGImage(output, from: output.extent) else { return }
        self.image = UIImage(cgImage: cgimg)
        #endif
    }

}

// https://gist.github.com/FlexMonkey/a18b0509ce8d2068457e
class ThresholdFilter: CIFilter {
    @objc dynamic var inputImage : CIImage?
    @objc dynamic var inputThreshold: CGFloat = 0.75

    let source =
        """
        kernel vec4 thresholdFilter(__sample image, float threshold) {
            float luma = (image.r * 0.2126) + (image.g * 0.7152) + (image.b * 0.0722);
            return (luma > threshold) ? vec4(1.0, 1.0, 1.0, 1.0) : vec4(0.0, 0.0, 0.0, 1.0);
        }
        """

    lazy var kernel = CIColorKernel(source: source)

    override var outputImage : CIImage! {
        guard let inputImage = inputImage, let thresholdKernel = kernel else {
            return nil
        }

        let extent = inputImage.extent
        let arguments = [inputImage, inputThreshold] as [Any]

        return thresholdKernel.apply(extent: extent, arguments: arguments)
    }
}

class OpaqueFilter: CIFilter {
    @objc dynamic var inputImage : CIImage?
    let kernel = CIColorKernel(source:
        """
        kernel vec4 thresholdFilter(__sample image) {
            return vec4(image.r, image.g, image.b, 1.0);
        }
        """
    )
    override var outputImage : CIImage! {
        guard let inputImage = inputImage, let kernel = kernel else {
            return nil
        }
        let extent = inputImage.extent
        let arguments = [inputImage] as [Any]
        return kernel.apply(extent: extent, arguments: arguments)
    }
}
