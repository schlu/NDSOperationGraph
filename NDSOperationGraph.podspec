#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "NDSOperationGraph"
  s.version          = "0.1.5"
  s.summary          = "A short description of NDSOperationGraph."
  s.description      = <<-DESC
                       An optional longer description of NDSOperationGraph

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/schlu/NDSOperationGraph"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nicholas Schlueter" => "schlueter@gmail.com" }
  s.source           = { :git => "https://github.com/schlu/NDSOperationGraph.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/schlu'

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets/*.png'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
end
