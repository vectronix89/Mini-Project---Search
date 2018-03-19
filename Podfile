# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Mini Project' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

pod 'SwiftyJSON', '3.0.0'
pod 'AlamofireImage', '~> 3.1'
pod 'AlamofireObjectMapper', '~> 5.0'
pod 'RxSwift',    '~> 4.0'
pod 'FontAwesome.swift'
pod 'LGButton'
pod 'RangeSeekSlider'
pod 'IQKeyboardManagerSwift'
pod 'SkyFloatingLabelTextField', '~> 3.0'
pod 'ReachabilitySwift'
pod 'SnapKit', '~> 4.0.0'


post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['RangeSeekSlider'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end

end
