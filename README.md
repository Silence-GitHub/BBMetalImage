# BBMetalImage

A Swift library for GPU-accelerated image/video processing based on Metal.

## Features

- [x] More than 60 built-in filters
- [x] Extensions for `UIImage` to get filtered image
- [x] Filter chain supported
- [x] Customized filter

## Requirements

- iOS 8.0+
- Swift 4.2

##  How to Use

### Image Extensions

`UIImage` extensions are the simplest way to get filtered image synchronously.

```swift
let filteredImage = image.bb_contrastFiltered(withContrast: 3)
```

### Filter Chain

The code below:

1. Captures image with a camera
2. The image captured by the camera is processed by 3 filters
3. The processed image is rendered to the metal view

```swift
// Set up Camera to capture image
let camera = BBMetalCamera(sessionPreset: .high)!

// Set up 3 filters to process image
let contrastFilter = BBMetalContrastFilter(contrast: 3)
let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)

// Set up metal view to display image
let metalView = BBMetalView(frame: frame)
view.addSubview(metalView)

// Set up filter chain
camera.add(consumer: contrastFilter)
    .add(consumer: lookupFilter)
    .add(consumer: sharpenFilter)
    .add(consumer: metalView)

// Start capturing
camera.start()
```

