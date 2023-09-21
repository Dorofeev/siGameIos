platform :ios, '14.0'
use_frameworks!

target 'SIOnline' do

pod "AlignedCollectionViewFlowLayout", '~> 1.1.2'
pod 'R.swift', '6.1.0'
pod 'Alamofire', '5.5'
pod 'PromiseKit', '6.8'
pod 'SwiftSignalRClient', '0.9.0'
pod 'ReSwift', '6.1.0'
pod 'ReSwiftThunk', '2.0.1'
pod 'EmojiPicker', :git => 'https://github.com/htmlprogrammist/EmojiPicker'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
