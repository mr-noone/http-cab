Pod::Spec.new do |s|
  s.name = 'HTTPCab'
  s.version = '3.1.3'
  
  s.summary = 'HTTPCab - network framework for HTTP requests and REST.'
  s.homepage = 'https://github.com/mr-noone/http-cab'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Aleksey Zgurskiy' => 'mr.noone@icloud.com' }
  
  s.platform = :ios, '8.0'
  
  s.source = { :git => 'https://github.com/mr-noone/http-cab.git', :tag => "#{s.version}" }
  s.source_files = 'Sources/HTTPCab/**/*.{swift}'
  s.swift_version = '5.0'
end
