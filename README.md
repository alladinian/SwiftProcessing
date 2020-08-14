# SwiftProcessing
A [Processing](https://processing.org/) Environment for Swift

> Please note that the project is under active development, so it is subject to frequent changes. 

![workflow status](https://github.com/alladinian/SwiftProcessing/workflows/Swift/badge.svg)

## What is it?
This project is an attempt to maintain the same Processing-style prototyping experience as much as possible. It also tries to follow the original apis in order to achieve sketch compatibility with minimal changes. It is _not_ a Swift Processing mode and is not affiliated with the Processing Foundation.

## What can I do with it?
Well, I think this quote from the Processing website offers an excellent intro:

> Processing is a flexible software sketchbook and a language for learning how to code within the context of the visual arts. Since 2001, Processing has promoted software literacy within the visual arts and visual literacy within technology. There are tens of thousands of students, artists, designers, researchers, and hobbyists who use Processing for learning and prototyping.

My personal motivation & inspiration for getting involved with this project was mainly [Daniel Shiffman](https://shiffman.net/)'s [excellent video series](https://www.youtube.com/c/TheCodingTrain/featured) (especially Coding Challenges & Nature of Code). 
If you've never watched any of Daniel's videos go ahead and do so, you wont regret it.

## Installation & Usage
This project is in the form of a Swift Package, supporting both iOS (v10+) & macOS (v10.12+). The package have no external dependencies.

Part of Processing's appeal is the simplicity & how quickly you can prototype ideas. In order to achieve a similar experience, I wanted to be able to compile sketches quickly without even opening Xcode if possible. 

So here is a workflow that I found to be working quite well (if you know a better way you are welcome to contribute or let me know):

1. Install [swift sh](https://github.com/mxcl/swift-sh)

   `brew install swift-sh`

   or

   `mint install mxcl/swift-sh`

   This will enable importing of packages in a Swift file.

2. Import `SwiftProcessing` in a .swift file in the editor of your choice and write a sketch:

```swift
#!/usr/bin/swift sh

import Cocoa
import SwiftProcessing // @alladinian

class FractalTreeSketch: SPSView {

    var angle: CGFloat!
    var slider: Slider!

    override func setup() {
        slider = createSlider(0, TWO_PI, PI/4, 0.01)
    }

    override func draw() {
        strokeWeight(1)
        background(20)
        angle = CGFloat(slider.doubleValue)
        stroke(255)
        translate(width/2, height)
        branch(height * 0.3)
    }

    func branch(_ len: CGFloat) {
        line(0, 0, 0, -len)
        translate(0, -len)
        if len > 4 {
            push()
            rotate(angle)
            branch(len * 0.67)
            pop()
            push()
            rotate(-angle)
            branch(len * 0.67)
            pop()
        }
    }
}

let sketch = FractalTreeSketch(size: .init(width: 400, height: 400))

launchSketch(sketch)
```

Finally, execute the sketch file:

`$ swift sh mySketch.swift`

or

`$ chmod u+x mySketch.swift`
`$ ./mySketch.swift`

This will launch a window and run your sketch.

![tree](https://i.ibb.co/c18BBRY/Fractal-Tree.gif)

There are some examples also included in the package, such as this beautiful noise wave

![noisewave](https://i.ibb.co/Wsjjx9W/Noise-Wave.gif)

## Technical Details
The current implementation relies on `CoreGraphics` to perform drawing and `CADisplayLink` / `CVDisplayLink` for screen updates. 
Eventually different renderers could be used with a protocol oriented approach for possible improvements in performance.
Another significant missing piece is glsl shaders and 3D support. We could leverage `SpriteKit` & `SceneKit` for that.

## Supported Features
See the dedicated [wiki page](https://github.com/alladinian/SwiftProcessing/wiki/Supported-Features) for currently supported features.

## Author
Vasilis Akoinoglou, alladinian@gmail.com  
Twitter: @alladinian

## License

**SwiftProcessing** is available under the MIT license. See the LICENSE file for more info.
