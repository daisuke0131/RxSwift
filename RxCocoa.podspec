Pod::Spec.new do |s|
  s.name             = "RxCocoa"
  s.version          = "4.5.0"
  s.summary          = "RxSwift Cocoa extensions"
  s.description      = <<-DESC
* UI extensions
* NSURL extensions
* KVO extensions
                        DESC
  s.homepage         = "https://github.com/daisuke0131/RxSwift"
  s.license          = 'MIT'
  s.author           = { "Daisuke Yamashita" => "dai.tachikoma@gmail.com" }
  s.source           = { :git => "https://github.com/daisuke0131/RxSwift.git", :branch => "4_5_0" }

  s.requires_arc          = true

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '9.0'

  s.source_files          = 'RxCocoa/**/*.{swift,h,m}', 'Platform/**/*.swift'
  s.exclude_files         = 'RxCocoa/Platform/**/*.swift', 'Platform/AtomicInt.swift'

  s.dependency 'RxSwift', '~> 4.4', '>= 4.4.2'
end
