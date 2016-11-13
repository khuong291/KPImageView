Pod::Spec.new do |s|
  s.name         = "KPImageView"
  s.version      = "0.0.1"
  s.summary      = "A super cool image affect in UIImageView."
  s.description  = "A super cool image affect in UIImageView."

  s.homepage     = "https://github.com/khuong291"
  s.screenshots  = "https://github.com/khuong291/KPImageView/blob/master/KPImageView.png"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Khuong Pham" => "dkhuong291@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/khuong291/KPImageView.git", :tag => "0.0.1" }

  s.source_files  = "KPImageView", "KPImageView/**/*.{h,m}"
  s.exclude_files = "KPImageView/Exclude"

  # s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
