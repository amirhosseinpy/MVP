platform :ios, '13.0'
inhibit_all_warnings!

def shared_pods
  
  pod "Resolver"
  pod 'SwiftLint'
  pod 'SnapKit'
  pod 'Kingfisher'
  
end

target 'MVP_imperative' do
  use_frameworks!
  shared_pods
end

target 'MVP_imperativeTests' do
  inherit! :search_paths
  use_frameworks!
  shared_pods
end

target 'MVP_imperativeUITests' do
  use_frameworks!
end
