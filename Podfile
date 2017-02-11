workspace 'Tunner'
use_frameworks!
platform :ios, '10.0'

def testFrameworks
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
end

target 'Tunner' do
  project 'Tunner.xcodeproj'

  target 'TunnerTests' do
    testFrameworks
  end

end

target 'TunnerKit' do
    project 'TunnerKit/TunnerKit.xcodeproj'
    
    pod 'AudioKit'
    
    target 'TunnerKitTests' do
        testFrameworks
    end
    
end
