require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNPayTm"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/opsway/react-native-paytm.git", :tag => "v#{s.version}" }
  s.source_files  = ["ios/**/*.{h,m}", "ios/PaymentSDK.framework/Headers/*.h"]
  s.public_header_files = "PaymentSDK.framework/Headers/*.h"

  s.dependency 'React'
  s.ios.vendored_frameworks = 'PaymentSDK.framework'
end
