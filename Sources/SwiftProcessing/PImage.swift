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
public class PImage: UIImageView {
    var rawPixels: UnsafePointer<UInt8>?
    public var pixels: UnsafeMutableBufferPointer<Pixel>?
}
typealias Image = UIImage
#endif

#if os(macOS)
import AppKit
public class PImage: NSImageView {
    var rawPixels: UnsafePointer<UInt8>?
    public var pixels: UnsafeMutableBufferPointer<Pixel>?
}
typealias Image = NSImage
#endif

//struct RGBA {
//    var pixels: UnsafeMutableBufferPointer<Pixel>
//    var width: Int
//    var height: Int
//}

public struct Pixel {
    var value: UInt32
    var red: UInt8 {
        get { UInt8(value & 0xFF) }
        set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
    }
    var green: UInt8 {
        get { UInt8((value >> 8) & 0xFF) }
        set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
    }
    var blue: UInt8 {
        get { UInt8((value >> 16) & 0xFF) }
        set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
    }
    var alpha: UInt8 {
        get { UInt8((value >> 24) & 0xFF) }
        set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
    }

    public init(value: UInt32) {
        self.value = value
    }

    public init(_ color: SPColor) {
        self.value = color.value
    }
}

public extension SPColor {
    var value: UInt32 {
        let r = Int(red  )
        let g = Int(green) << 8
        let b = Int(blue ) << 16
        let a = Int(alpha) << 24
        return UInt32(a + r + g + b)
    }
}

public extension UnsafeMutableBufferPointer where Element == Pixel {
    subscript(index: Int) -> SPColor {
        get {
            let pc: Pixel = self[index]
            return SPColor(Int(pc.red), Int(pc.green), Int(pc.blue), Int(pc.alpha))
        }
        set(newValue) {
            self[index] = Pixel(value: newValue.value)
        }
    }
}

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

    var width: Int {
        Int(bounds.width)
    }

    var height: Int {
        Int(bounds.height)
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

    func loadPixels() {
        guard let image = image else { return }
        guard let cgImage = image.cgImage else { return }
        guard pixels == nil else { return }
        let size = image.size
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        guard let imageContext = CGContext(data: imageData,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo)
        else { return }

        imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }

    private func loadRawPixels() {
        guard let image = image?.cgImage else { return }
        guard let provider = image.dataProvider else { return }
        let pixelData = provider.data
        rawPixels = CFDataGetBytePtr(pixelData)
    }

    func updatePixels() {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        guard let imageContext = CGContext(data: pixels?.baseAddress,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo,
                                           releaseCallback: nil,
                                           releaseInfo: nil)
        else { return }

        guard let cgImage = imageContext.makeImage() else { return }

        self.image = Image(cgImage: cgImage, size: .init(width: width, height: height))
    }

}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
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
