Pod::Spec.new do |s|
  s.name             = 'ActionsList'
  s.version          = '0.9.0'
  s.summary          = 'Present Apple QuickActionsMenu-like lists in your app.'
  s.description      = <<-DESC
ActionsList is an iOS framework for presenting actions lists similar to Apple's Quick Actions menu. It is the best replace for the Android's floating action button in iOS if your app is following the iOS Design Guidelines.
                       DESC

  s.homepage         = 'https://github.com/LowKostKustomz/ActionsList'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LowKostKustomz' => 'mierosh@gmail.com' }
  s.source           = { :git => 'https://github.com/LowKostKustomz/ActionsList.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LowKostKustomz'
  s.ios.deployment_target = '9.0'
  s.source_files = 'ActionsList/Classes/**/*.{swift}'
  s.frameworks = 'UIKit'
end
