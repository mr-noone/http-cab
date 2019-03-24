Pod::Spec.new do |s|
  s.name = 'HTTPCab'
  s.version = '2.1.0'
  
  s.summary = 'HTTPCab - network framework for HTTP requests and REST.'
  s.homepage = 'https://github.com/nullgr/http-cab'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Aleksey Zgurskiy' => 'mr.noone@icloud.com' }
  
  s.platform = :ios, '8.0'
  
  s.source = { :git => 'https://github.com/nullgr/http-cab.git', :tag => "#{s.version}" }
  s.source_files = 'HTTPCab/HTTPCab/**/*.{swift}'
  s.swift_version = '4.2'
end
