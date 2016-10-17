source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

pod 'Alamofire'
pod 'SwiftyJSON', '3.0.0'
pod 'MGSwipeTableCell'
pod 'SCLAlertView', :git => 'https://github.com/vikmeup/SCLAlertView-Swift'
pod 'Starscream'
pod "SlackTextViewController"
pod 'SnapKit'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
