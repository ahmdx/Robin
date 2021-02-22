#
# Be sure to run `pod lib lint Robin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Robin'
  s.version          = '0.90.0'
  s.summary          = 'A notification scheduler written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Robin is a notification scheduler that provides an interface to schedule notifications using the UserNotifications framework.
                       DESC

  s.homepage         = 'https://github.com/ahmdx/Robin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ahmed Mohamed' => 'dev@ahmd.pro' }
  s.source           = { :git => 'https://github.com/ahmdx/Robin.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '10.0'

  s.source_files = 'Robin/Classes/**/*'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Robin/Tests/**/*'
  end
end
