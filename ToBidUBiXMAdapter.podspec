
Pod::Spec.new do |s|
  s.name             = 'ToBidUBiXMAdapter'
  s.version          = '4.1.11.0'
  s.summary          = 'ToBid UBiX聚合广告变现SDK Adapter'
  s.homepage         = 'https://www.ubixai.com/product/md'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhugq' => 'guoqiang.zhu@ubixai.com' }
  s.source           = { :git => 'https://github.com/ubixai/WindMillUBiXMAdapter.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'

  s.static_framework = true
  s.ios.source_files = 'WindMillUBiXMAdapter/**/*.{h,m}'
  # Public
  s.ios.public_header_files =  'WindMillUBiXMAdapter/**/*.h'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'OTHER_LINK_FLAG' => '$(inherited) -ObjC' }
  
 s.dependency 'ToBid-iOS','4.1.11'
 s.dependency 'UBiXMediationSDK', '2.6.3'
 s.dependency 'UBiXMerakSDK','2.5.0'


end
