Pod::Spec.new do |s|
  s.name        = "SwiftyProgressBar"
  s.version     = "0.1.0"
  s.summary     = "SwiftyProgressBar, progress bar"
  s.homepage    = "https://github.com/TorIsHere/SwiftyProgressBar"
  s.license     = { :type => "Apache2.0" }
  s.authors     = { "kittikorn" => "kittikorn.a@gmail.com" }
  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/TorIsHere/SwiftyProgressBar.git", :tag => s.version }
  s.source_files = "SwiftyProgressBar/*.swift"
end

