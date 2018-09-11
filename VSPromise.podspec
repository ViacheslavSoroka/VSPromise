Pod::Spec.new do |s|
  s.name      = "VSPromise"
  s.version   = "1.0.1"
  s.summary   = "A simple lightweight Ojective-C promises"
  s.description  = <<-DESC
                     VSPromise is a simple Objective-C implementation of promises.
                     DESC
  s.homepage  = "https://github.com/ViacheslavSoroka/VSPromise"
  s.license   = { :type => "MIT", :file => "LICENSE" }
  s.author    = { "Viacheslav Soroka" => "viacheslav.soroka@tutanota.com" }
  s.source    = { :git => "https://github.com/ViacheslavSoroka/VSPromise.git",
                  :tag => s.version.to_s }

  # Platform setup
  s.requires_arc          = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'

  # Preserve the layout of headers in the Module directory
  s.header_mappings_dir   = 'Source'
  s.source_files          = 'Source/**/*.{swift,h,m,c,cpp}'
end
