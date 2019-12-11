# BBMetalImage

A high performance Swift library for GPU-accelerated image/video processing based on Metal.

This library is highly inspired by GPUImage.

## Performance

Test libraries are BBMetalImage (0.1.1) and GPUImage (0.1.7). Test device is iPhone 7 with iOS 12.1. The code can be found in [CompareImageLib](CompareImageLib) project and the test result data can be found in [CompareImageLib.numbers](README_resources/CompareImageLib.numbers).

- BBMetalImage has low memory usage for processing image.

![](README_resources/compare_image.png)

- BBMetalImage has low CPU usage and high speed for camera capturing, processing and rendering. 

![](README_resources/compare_camera.png)

## Features

- [x] More than 70 built-in filters
- [x] Filter chain supported
- [x] Customized filter
- [x] High performance

## Requirements

- iOS 10.0+
- Swift 5

## Installation

Install with CocoaPods:

1. Add `pod 'BBMetalImage'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Add `import BBMetalImage` to the Swift source file.

##  How to Use

### Single Filter

Call `filteredImage(with:)` method of a filter is the simplest way to get filtered image synchronously.

```swift
let filteredImage = BBMetalContrastFilter(contrast: 3).filteredImage(with: image)
```

### Filter Chain

#### Capture, Preview and Recording

The code below:

1. Captures image and audio with a camera
2. The image captured by the camera is processed by 3 filters
3. The processed image is rendered to the metal view
4. The processed image and audio are written to a video file
5. Do something after writing the video file

```swift
// Hold camera and video writer
var camera: BBMetalCamera!
var videoWriter: BBMetalVideoWriter!

func setup() {
    // Set up camera to capture image
    camera = BBMetalCamera(sessionPreset: .hd1920x1080)!

    // Set up 3 filters to process image
    let contrastFilter = BBMetalContrastFilter(contrast: 3)
    let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
    let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)

    // Set up metal view to display image
    let metalView = BBMetalView(frame: frame)
    view.addSubview(metalView)

    // Set up video writer
    let filePath = NSTemporaryDirectory() + "test.mp4"
    let url = URL(fileURLWithPath: filePath)
    videoWriter = BBMetalVideoWriter(url: url, frameSize: BBMetalIntSize(width: 1080, height: 1920))

    // Set camera audio consumer to record audio
    camera.audioConsumer = videoWriter

    // Set up filter chain
    camera.add(consumer: contrastFilter)
        .add(consumer: lookupFilter)
        .add(consumer: sharpenFilter)
        .add(consumer: metalView)

    sharpenFilter.add(consumer: videoWriter)

    // Start capturing
    camera.start()

    // Start writing video file
    videoWriter.start()
}

func finishRecording() {
    videoWriter.finish {
         // Do something after recording the video file
    }
}
```

#### Capture Image

```swift
// Hold camera
var camera: BBMetalCamera!

func setup() {
    // Set up camera to capture image
    // Set `canTakePhoto` to true and set `photoDelegate` to nonnull
    camera = BBMetalCamera(sessionPreset: .hd1920x1080)!
    camera.canTakePhoto = true
    camera.photoDelegate = self

    // Set up metal view to display image
    let metalView = BBMetalView(frame: frame)
    view.addSubview(metalView)

    // Set up filter chain
    camera.add(consumer: metalView)

    // Start capturing
    camera.start()
}

func takePhoto() {
    camera.takePhoto()
}

// BBMetalCameraPhotoDelegate
func camera(_ camera: BBMetalCamera, didOutput texture: MTLTexture) {
    // Do something to the photo texture
    // Note: the `texture` is the original photo which is not filtered even though there are filters in the filter chain
}
```

#### Process Video File

```swift
// Hold video source and writer
var videoSource: BBMetalVideoSource!
var videoWriter: BBMetalVideoWriter!

func setup() {
    // Set up video writer
    let filePath = NSTemporaryDirectory() + "test.mp4"
    let outputUrl = URL(fileURLWithPath: filePath)
    videoWriter = BBMetalVideoWriter(url: outputUrl, frameSize: BBMetalIntSize(width: 1080, height: 1920))

    // Set up video source
    let sourceURL = Bundle.main.url(forResource: "test_video_2", withExtension: "mov")!
    videoSource = BBMetalVideoSource(url: sourceURL)

    // Set video source audio consumer to write audio data
    videoSource.audioConsumer = videoWriter

    // Set up 3 filters to process image
    let contrastFilter = BBMetalContrastFilter(contrast: 3)
    let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
    let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)

    // Set up filter chain
    videoSource.add(consumer: contrastFilter)
        .add(consumer: lookupFilter)
        .add(consumer: sharpenFilter)
        .add(consumer: videoWriter)

    // Start receiving Metal texture and writing video file
    videoWriter.start()

    // Start reading and processing video frame and auido data
    videoSource.start { [weak self] (_) in
        // All video data is processed
        guard let self = self else { return }

        // Finish writing video file
        self.videoWriter.finish {
            // Do something after writing the video file
        }
    }
}
```

#### Process Image Synchronously

```swift
// Set up image source
let imageSource = BBMetalStaticImageSource(image: image)

// Setup 3 filters to process image
let contrastFilter = BBMetalContrastFilter(contrast: 3)
let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)

// Set up filter chain
// Make last filter run synchronously
imageSource.add(consumer: contrastFilter)
    .add(consumer: lookupFilter)
    .add(consumer: sharpenFilter)
    .runSynchronously = true

// Start processing
imageSource.transmitTexture()

// Get filtered image
let filteredImage = sharpenFilter.outputTexture?.bb_image
```

#### Process Image Asynchronously

```swift
// Hold image source
var imageSource: BBMetalStaticImageSource!

func process() {
    // Set up image source
    imageSource = BBMetalStaticImageSource(image: image)
    
    // Setup 3 filters to process image
    let contrastFilter = BBMetalContrastFilter(contrast: 3)
    let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
    let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)
    
    // Set up filter chain
    // Add complete handler to last filter
    weak var wLastFilter = sharpenFilter
    imageSource.add(consumer: contrastFilter)
        .add(consumer: lookupFilter)
        .add(consumer: sharpenFilter)
        .addCompletedHandler { [weak self] _ in
            if let filteredImage = wLastFilter?.outputTexture?.bb_image {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    // Display filtered image
                }
            }
    }
    
    // Start processing
    imageSource.transmitTexture()
}
```

## Built-in Filters

- Brightness
- Exposure
- Contrast
- Saturation
- Gamma
- Levels
- Color Matrix
- RGBA
- Hue
- Vibrance
- White Balance
- Highlight Shadow
- Highlight Shadow Tint
- Lookup
- Color Inversion
- Monochrome
- False Color
- Haze
- Luminance
- Luminance Threshold
- Erosion
- RGBA Erosion
- Dilation
- RGBA Dilation
- Chroma Key
- Crop
- Resize
- Rotate
- Flip
- Sharpen
- Unsharp Mask
- Gaussian Blur
- Box Blur
- Zoom Blur
- Motion Blur
- Tilt Shift
- Blend Modes
  - Normal
  - Chroma Key
  - Dissolve
  - Add
  - Subtract
  - Multiply
  - Divide
  - Overlay
  - Darken
  - Lighten
  - Color
  - Color Burn
  - Color Dodge
  - Screen
  - Exclusion
  - Difference
  - Hard Light
  - Soft Light
  - Alpha
  - Source Over
  - Hue
  - Saturation
  - Luminosity
  - Linear Burn
  - Mask
- Pixellate
- Polar Pixellate
- Polka Dot
- Halftone
- Crosshatch
- Sketch
- Threshold Sketch
- Toon
- Posterize
- Kuwahara
- Swirl
- Convolution 3x3
- Emboss
- Sobel Edge Detection
- Bilateral Blur
- Beauty

## License

BBMetalImage is released under the MIT license. See [LICENSE](LICENSE) for details.