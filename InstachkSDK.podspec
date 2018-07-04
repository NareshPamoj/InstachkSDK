Pod::Spec.new do |s|
s.platform         = :ios
s.name             = 'InstachkSDK'
s.version          = '0.1.0'
s.summary          = 'Instachk SDK to render nearby offers'
s.description      = <<-DESC
Instachk offers SDK lets you display nearby offers
DESC

s.homepage         = 'https://github.com/NareshPamoj/InstachkSDK'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Naresh' => 'naresh@instachk.today' }
s.source           = { :git => 'https://github.com/NareshPamoj/InstachkSDK.git', :tag => s.version.to_s }


s.ios.deployment_target = '10.3'
s.swift_version = '4.0'

# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'Starscream'
s.dependency 'ARSLineProgress'
s.dependency 'Kingfisher'

s.source_files = 'InstachkSDK/**/*.{swift}'
s.resources = 'InstachkSDK/**/*.{png,jpeg,jpg,storyboard,xib}'

#s.resource_bundles = {
# 'InstachkSDK' => ['InstachkSDK/Assets/*.png']
#}

end
