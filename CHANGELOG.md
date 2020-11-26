# Change Log

## [1.1.9](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.9) - 2020-11-26

### Change

- Implement BBMetalView init(coder:)
- Make BBMetalDefaultTexture public
- Make BBMetalVideoTextureItem public

## [1.1.8](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.8) - 2020-10-23

### Fix

- Camera capturing photo texture wrong color bug

## [1.1.7](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.7) - 2020-10-07

### Add

- BBMetalCamera preprocessVideo block
- BBMetalCamera capturePhoto(completion:) function
- BBMetalVideoSource preprocessVideo block
- BBMetalTransformFilter

### Change

- BBMetalCamera takePhoto() function
- BBMetalBaseFilter addCompletedHandler(_:) function

### Fix

- Camera video frame camera position nil bug
- BBMetalVideoSource orientation bug

## [1.1.6](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.6) - 2020-08-16

### Add

- BBMetalVignetteFilter
- BBMetalBulgeFilter
- BBMetalPinchFilter

### Change

- All texture samplers use linear mag_filer and min_filter to avoid pixelation

### Fix

- UIImage texture incorrect orientation bug
- Image data no texture bug

## [1.1.5](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.5) - 2020-08-14

### Change

- BBMetalCamera adds mutitpleSessions property, uses indepent audio session, and remo
ves adjustSampleTime function to fix video and audio out of sync bug if switching camera position while recording

## [1.1.4](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.4) - 2020-08-12

### Add

- BBMetalVideoWriter adds start handler
- BBMetalCamera adds adjustSampleTime(_:) function

### Change

- BBMetalCamera makes removeMetadataOutput function public
- BBMetalGaussianBlurFilter can set sigma value
- BBMetalBoxBlurFilter can set kernel width and height

## [1.1.3](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.3) - 2020-08-03

### Add

- BBMetalMultipleImageSource
- BBMetalStaticImageSource adds update texture functions
- BBMetalCamera willTransmitTexture adds sample time

### Fix

- Video frame sample time nil bug

## [1.1.2](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.2) - 2020-06-01

### Fix

- Fix Xcode 11.5 release mode empty CGImage bug

## [1.1.1](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.1) - 2020-05-11

### Fix

- Fix chroma key filter shader bug

## [1.1.0](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.1.0) - 2019-12-12

### Add

- BBMetalUISource

### Change

- Replace deprecated float3 with SIMD3\<Float\>

## [1.0.11](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.11) - 2019-11-25

### Add

- BBMetalKuwaharaFilter
- BBMetalConvolution3x3Filter
- BBMetalEmbossFilter

## [1.0.10](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.10) - 2019-11-01

### Fix

- Fix hue filter black pixel bug
- Rotate filter out of range bug

## [1.0.9](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.9) - 2019-10-17

### Add

- Filter can remove completion callback

### Change

- Change dilation and erosion filters into two pass for performance

## [1.0.8](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.8) - 2019-09-18

### Add

- BBMetalErosionFilter
- BBMetalRGBAErosionFilter
- BBMetalDilationFilter
- BBMetalRGBADilationFilter
- BBMetalPassThroughFilter

### Fix

- MPSKernel filter not call completions bug

## [1.0.7](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.7) - 2019-08-16

### Add

- Video writer adds progress callback

## [1.0.6](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.6) - 2019-08-14

### Fix

- Fix rotate filter empty pixel bug

## [1.0.5](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.5) - 2019-08-07

### Fix

- Fix metal view aliasing bug

## [1.0.4](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.4) - 2019-08-05

### Add

- Camera adds metadata output

## [1.0.3](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.3) - 2019-07-26

### Add

- Filter adds useMainBundleKernel
- Video source adds BBMetalVideoSourceProgress

### Fix

- Fix video frame stuttering bug

## [1.0.2](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.2) - 2019-07-18

### Add

- BBMetalSobelEdgeDetectionFilter
- BBMetalBilateralBlurFilter
- BBMetalBeautyFilter

## [1.0.1](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.1) - 2019-07-10

### Fix

- If MTKTextureLoader can not decode CGImage, draw CGImage and create texture

## [1.0.0](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/1.0.0) - 2019-05-21

### Change

- Swift 5

## [0.1.3](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/0.1.3) - 2019-05-14

### Add

- BBMetalCamera can take photo

## [0.1.2](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/0.1.2) - 2019-05-07

### Add

- BBMetalVideoSource
- BBMetalVideoWriter

## [0.1.1](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/0.1.1) - 2019-04-23

### Add

- BBMetalCamera adds benchmark

## [0.1.0](https://github.com/Silence-GitHub/BBMetalImage/releases/tag/0.1.0) - 2019-04-19

First version
