Pod::Spec.new do |s|
  s.name         = "KPImageView"
  s.version      = "0.0.3"
  s.summary      = "UIImageView with Ken Burns effect."
  s.homepage     = "https://github.com/khuong291/KPImageView"
  s.license      = 'MIT'
  s.author       = { "khuong291" => "dkhuong291@gmail.com" }
  s.source       = { :git => "https://github.com/khuong291/KPImageView.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'KPImageView/KPImageView.swift'
end