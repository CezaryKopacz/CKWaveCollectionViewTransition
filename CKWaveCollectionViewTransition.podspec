Pod::Spec.new do |s|
  s.name         = "CKWaveCollectionViewTransition"
  s.version      = "1.0.1"
  s.summary      = "Wave like transition between two or more collection view."
  s.homepage     = "https://github.com/CezaryKopacz/CKWaveCollectionViewTransition"
  s.license      = { :type => "MIT" }
  s.author       = { "Cezary Kopacz" => "salvation.sv@gmail.com" }
  s.source       = { :git => "https://github.com/CezaryKopacz/CKWaveCollectionViewTransition.git", :tag => "1.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{swift}"
  s.ios.deployment_target = "8.0"
end
