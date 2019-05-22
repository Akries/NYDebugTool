Pod::Spec.new do |s|
  
  s.name         = "NYDebugTool"
  s.version      = "1.7.4"
  s.summary      = "供iOS开发切换环境Debug使用工具"

  s.description  = "供iOS开发切换环境Debug使用工具,悬浮于window之上切换环境使用"

  s.homepage     = "https://github.com/Akries/NYDebugTool.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Akries.NY" => "akries@outlook.com" }
  s.source       = { :git => "https://github.com/Akries/NYDebugTool.git", :tag =>'1.7.4' }

  s.platform     = :ios, '8.0'
  s.source_files  = "**/*.{h,m}"
  #s.resources = ["**/*.{xib}"]
   s.resource = "**/*.bundle"


  s.requires_arc = true



end
