# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

use_frameworks!

def project_pods
  pod 'RxSwift'
  pod 'RxOptional'
  pod 'Moya/RxSwift'
  pod 'Kingfisher'
end

target 'RxSwiftAndMVVM' do
  project_pods
  target 'RxSwiftAndMVVMTests' do
    inherit! :search_paths
    pod 'OHHTTPStubs/Swift'
    pod 'RxBlocking'
    pod 'RxTest'
  end
end


