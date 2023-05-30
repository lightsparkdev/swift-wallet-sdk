Pod::Spec.new do |s|
  s.name             = 'LightsparkWallet'
  s.version          = '1.2.1'
  s.summary          = 'Lightspark wallet swift SDK'
  s.homepage         = 'https://www.lightspark.com/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Lightspark Group, Inc.' => 'info@lightspark.com' }
  s.source           = { :git => 'https://github.com/lightsparkdev/swift-wallet-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.5'
  s.source_files = 'Sources/LightsparkWallet/**/*'
end
