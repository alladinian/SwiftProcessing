//
//  File.swift
//  
//
//  Created by Vasilis Akoinoglou on 7/8/20.
//

import Foundation
import CoreGraphics
import Accelerate

func applyConvolutionFilterToImage(image: CGImage, _ kernel: [Int16], _ divisor: Int) -> CGImage? {

    precondition(kernel.count == 9 || kernel.count == 25 || kernel.count == 49, "Kernel size must be 3x3, 5x5 or 7x7.")

    let kernelSide   = UInt32(sqrt(Float(kernel.count)))
    let imageRef     = image
    let inProvider   = imageRef.dataProvider!
    let inBitmapData = inProvider.data
    let width        = UInt(imageRef.width)
    let height       = UInt(imageRef.height)

    var inBuffer = vImage_Buffer(data: UnsafeMutablePointer(mutating: CFDataGetBytePtr(inBitmapData)),
                                 height: height,
                                 width: width,
                                 rowBytes: imageRef.bytesPerRow)

    let pixelBuffer = malloc(imageRef.bytesPerRow * imageRef.height)

    var outBuffer = vImage_Buffer(data: pixelBuffer,
                                  height: height,
                                  width: width,
                                  rowBytes: imageRef.bytesPerRow)

    var backgroundColor : Array<UInt8> = [0,0,0,0]

    _ = vImageConvolve_ARGB8888(&inBuffer,
                                &outBuffer,
                                nil,
                                0,
                                0,
                                kernel,
                                kernelSide,
                                kernelSide,
                                Int32(divisor),
                                &backgroundColor,
                                UInt32(kvImageBackgroundColorFill))

    let outImage = CGImage.fromvImageOutBuffer(outBuffer)

    free(pixelBuffer)

    return outImage
}

private extension CGImage {
    static func fromvImageOutBuffer(_ outBuffer: vImage_Buffer) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        let context = CGContext(data: outBuffer.data,
                                width: Int(outBuffer.width),
                                height: Int(outBuffer.height),
                                bitsPerComponent: 8,
                                bytesPerRow: outBuffer.rowBytes,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)!

        return context.makeImage()
    }
}
