# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Grocery List' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Grocery List
pod 'BulletinBoard'
pod 'Lightbox'
pod 'BEMCheckBox'
pod 'InstantSearchVoiceOverlay', '~> 1.1.0'


post_install do |pi|
	pi.pods_project.targets.each do |t|
		t.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
		end
	end
end
end
