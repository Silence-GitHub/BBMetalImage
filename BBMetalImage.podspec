Pod::Spec.new do |s|

  s.name         = 'BBMetalImage'
  s.version      = '1.0.10'
  s.summary      = 'A Swift library for GPU-accelerated image/video processing based on Metal.'

  s.description  = <<-DESC
                   More than 70 built-in filters.
                   Filter chain supported.
                   Customized filter.
                   High performance.
                   DESC

  s.homepage     = 'https://github.com/Silence-GitHub/BBMetalImage'

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { 'Kaibo Lu' => 'lukaibolkb@gmail.com' }

  s.platform     = :ios, '10.0'

  s.swift_version = '5.0'

  s.source       = { :git => 'https://github.com/Silence-GitHub/BBMetalImage.git', :tag => s.version }

  s.requires_arc = true

  s.source_files  = 'BBMetalImage/BBMetalImage/*.{h,swift,metal}'
  s.exclude_files = 'BBMetalImage/BBMetalImage/MultipleVideoSource.swift'

  s.private_header_files = 'BBMetalImage/BBMetalImage/BBMetalShaderTypes.h'

end
