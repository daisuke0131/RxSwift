Pod::Spec.new do |s|
  s.name             = "RxAtomic"
  s.version          = "4.4.2"
  s.summary          = "Atomic primitives for RxSwift"
  s.description      = <<-DESC
Atomic primitives for RxSwift.
                        DESC
  s.homepage         = "https://github.com/daisuke0131/RxSwift"
  s.license          = 'MIT'
  s.author           = { "Daisuke Yamashita" => "dai.tachikoma@gmail.com" }
  s.source           = { :git => "https://github.com/daisuke0131/RxSwift.git", :branch => "4_5_0" }

  s.requires_arc          = true

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '9.0'

  s.source_files          = 'RxAtomic/**/*.{c,h}'
end
