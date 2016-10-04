# Podfile

# Select the appropriate platform below
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "9.1"
inhibit_all_warnings!
use_frameworks!

target 'Trucks' do
	pod 'ObjectMapper'
	pod 'Mapbox-iOS-SDK'
	pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', :submodules => true
	pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', :submodules => true
end


post_install do |installer|
  # Disable bitcode for now.
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
	  config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
