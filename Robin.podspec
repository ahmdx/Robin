#
# Be sure to run `pod lib lint Robin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Robin'
  s.version          = '0.1.1'
  s.summary          = 'A backwards-compatible notification scheduler written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Robin is a backwards-compatible notification scheduler that provides a universal interface to schedule notifications using both UILocalNotification and UserNotifications.
                       DESC

  s.homepage         = 'https://github.com/ahmedabadie/Robin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ahmedabadie' => 'badie.ahmed@icloud.com' }
  s.source           = { :git => 'https://github.com/ahmedabadie/Robin.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ahmedabadie'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Robin/Classes/**/*'
end
