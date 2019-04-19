# BBMetalImage

A Swift library for GPU-accelerated image/video processing based on Metal.

## Features

- [x] More than 60 built-in filters
- [x] Filter chain supported
- [x] Customized filter

## Requirements

- iOS 10.0+
- Swift 4.2

##  How to Use

### Single filter

Call `filteredImage(with:)` method of a filter is the simplest way to get filtered image synchronously.

```swift
let filteredImage = BBMetalContrastFilter(contrast: 3).filteredImage(with: image)
```

### Filter Chain

The code below:

1. Captures image with a camera
2. The image captured by the camera is processed by 3 filters
3. The processed image is rendered to the metal view

```swift
// Hold camera
var camera: BBMetalCamera!

func setup() {
    // Set up Camera to capture image
    camera = BBMetalCamera(sessionPreset: .high)!

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
}
```

#### Process image synchronously

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

#### Process image asynchronously

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

