workspace 'Tuner'
use_frameworks!
platform :ios, '10.0'

def testFrameworks
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
end

target 'Tuner' do
  project 'Tuner.xcodeproj'
  
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Cartography'
  pod 'AudioKit'
  pod 'pop'

  target 'TunerTests' do
    testFrameworks
  end

end

target 'TunerKit' do
    project 'TunerKit/TunerKit.xcodeproj'

    pod 'AudioKit'
    
    target 'TunerKitTests' do
        testFrameworks
    end
    
end
