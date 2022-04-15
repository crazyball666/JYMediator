#
# Be sure to run `pod lib lint JYMeditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JYMediator'
  s.version          = '0.0.1'
  s.summary          = 'A short description of JYMediator.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/crazyball666/JYMediator.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sujiahao' => 'sujiahao@37.com' }
  s.source           = { :git => 'https://github.com/crazyball666/JYMediator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = ['5.0']


  s.source_files = 'JYMediator/Classes/**/*'
end
