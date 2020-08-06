# SwiftProcessing
A [Processing](https://processing.org/) Environment for Swift

> Please note that the project is under active development, so it is subject to frequent changes. 

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
This is a list of features currently implemented. You can use this list as a reference or even a starting point for contributing to this project. You can find the full list of Processing features [here](https://processing.org/reference/).

**Shape / 2D Primitives**
- [x] arc()
- [x] circle()
- [x] ellipse()
- [x] line()
- [x] point()
- [x] quad()
- [x] rect()
- [x] square()
- [x] triangle()

**Input / Mouse**
- [x] mouseButton
- [x] mouseClicked()
- [x] mouseDragged()
- [x] mouseMoved()
- [x] mousePressed()
- [x] mousePressed
- [x] mouseReleased()
- [x] mouseWheel()
- [x] mouseX
- [x] mouseY
- [x] pmouseX
- [x] pmouseY

**PVector**
- [x] set()
- [x] random2D()
- [x] random3D()
- [x] fromAngle()
- [x] copy()
- [x] mag()
- [x] magSq()
- [x] add()
- [x] sub()
- [x] mult()
- [x] div()
- [x] dist()
- [x] dot()
- [x] cross()
- [x] normalize()
- [x] limit()
- [x] setMag()
- [x] heading()
- [x] rotate()
- [x] lerp()
- [x] angleBetween()
- [x] array()

**PImage**
- [ ] createImage()
- [x] loadImage()
- [ ] pixels
- [x] width
- [x] height
- [ ] loadPixels()
- [ ] updatePixels()
- [ ] resize()
- [ ] get()
- [ ] set()
- [ ] mask()
- [x] filter()
- [ ] copy()
- [ ] blend()
- [ ] save()

**PImage / Filters**
- [x] THRESHOLD
- [x] GRAY
- [ ] OPAQUE
- [x] INVERT
- [x] POSTERIZE
- [x] BLUR
- [ ] ERODE
- [ ] DILATE

**Shape / Curves**
- [x] bezier()
- [ ] bezierDetail()
- [ ] bezierPoint()
- [ ] bezierTangent()
- [x] curve()
- [ ] curveDetail()
- [ ] curvePoint()
- [ ] curveTangent()
- [ ] curveTightness()

**Shape / Attributes**
- [x] ellipseMode()
- [ ] rectMode()
- [x] strokeCap()
- [x] strokeJoin()
- [x] strokeWeight()

**Shape / Vertex**
- [ ] beginContour()
- [x] beginShape()
- [ ] bezierVertex()
- [ ] curveVertex()
- [ ] endContour()
- [x] endShape()
- [ ] quadraticVertex()
- [x] vertex()

**Color / Setting**
- [x] background()
- [x] clear()
- [ ] colorMode()
- [x] fill()
- [x] noFill()
- [x] noStroke()
- [x] stroke()

**Color / Creating & Reading**
- [x] alpha()
- [x] blue()
- [x] brightness()
- [x] color()
- [x] green()
- [x] hue()
- [ ] lerpColor()
- [x] red()
- [x] saturation()

**Math / Calculation**
- [x] abs()
- [x] ceil()
- [x] constrain()
- [x] dist()
- [x] exp()
- [x] floor()
- [x] lerp()
- [x] log()
- [x] mag()
- [x] map()
- [x] max()
- [x] min()
- [x] norm()
- [x] pow()
- [x] round()
- [x] sq()
- [x] sqrt()

**Math / Trigonometry**
- [x] acos()
- [x] asin()
- [x] atan()
- [x] atan2()
- [x] cos()
- [x] degrees()
- [x] radians()
- [x] sin()
- [x] tan()

**Math / Random**
- [x] noise()
- [ ] noiseDetail()
- [ ] noiseSeed()
- [x] random()
- [x] randomGaussian()
- [ ] randomSeed()

**Time & Date**
- [x] day()
- [x] hour()
- [x] millis()
- [x] minute()
- [x] month()
- [x] second()
- [x] year()

**Constants**
- [x] HALF_PI
- [x] PI
- [x] QUARTER_PI
- [x] TAU
- [x] TWO_PI

## Authors
Vasilis Akoinoglou, alladinian@gmail.com  
Twitter: @alladinian

## License

**SwiftProcessing** is available under the MIT license. See the LICENSE file for more info.
