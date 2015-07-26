#
# Be sure to run `pod lib lint HJShareMenu.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HJShareMenu"
  s.version          = "0.1.0"
  s.summary          = "A short description of HJShareMenu."
  s.description      = <<-DESC
                       An optional longer description of HJShareMenu

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/jiehu5114/HJShareMenu"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "hujie" => "jiehu5114@qq.com" }
  s.source           = { :git => "https://github.com/jiehu5114/HJShareMenu.git", :tag => s.version.to_s }
  s.social_media_url = 'http://jiehu5114.gitcafe.io/blog/archives/'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'


  s.public_header_files = 'Pod/Classes/**/*.h'
  s.resources = "Pod/HJShareMenu.bundle"

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
