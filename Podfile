# Podfile

# Select the appropriate platform below
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "9.1"
inhibit_all_warnings!
use_frameworks!

target 'Trucks' do
	pod 'ObjectMapper', '~> 1.5.0'
	pod 'Mapbox-iOS-SDK'
	pod 'RealmSwift'
end


post_install do |installer|
  # Disable bitcode for now.
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
