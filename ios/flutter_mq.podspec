#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_mq'
  s.version          = '0.0.2'
  s.summary          = 'A new Flutter plugin for meiqia'
  s.description      = <<-DESC
A new Flutter plugin for meiqia
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'YePaoFu' => 'nightwlovesking@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Meiqia'
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end

