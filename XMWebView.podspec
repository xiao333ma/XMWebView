Pod::Spec.new do |s|
  s.name             = 'XMWebView'
  s.version          = '1.0'
  s.summary          = 'webView'
  s.description      = '一个可以定制的 webVeiw '
  s.homepage         = 'https://github.com/xiao333ma/XMWebView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiao3333ma@gmail.com' => 'xiao3333ma@gmail.com' }
  s.source           = { :git => 'https://github.com/xiao333ma/XMWebView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.public_header_files = 'XMWebView/Classes/**/.h'
  s.source_files = 'XMWebView/Classes/**/*.{h,m}'
  s.resource     = 'XMWebView/Resources/XMWebView.bundle'
  s.frameworks = "UIKit", "WebKit"
  s.dependency "Masonry"
end