source 'https://github.com/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '15.0'
#Suggested fix for the Xcode compiler warning to update project settings
#https://stackoverflow.com/questions/37160688/set-deployment-target-for-cocoapodss-pod
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
target 'AnagramSolver' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AnagramSolver
  pod 'Google-Mobile-Ads-SDK'
    
  target 'AnagramSolverTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
