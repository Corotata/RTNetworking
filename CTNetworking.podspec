Pod::Spec.new do |s|


  s.name         = "CTNetworking"
  s.version      = "1.0.0"
  s.summary      = "CTNetworking is an iOS discrete HTTP API calling framework based on AFNetworking."
  s.description  = <<-DESC
                   CTNetworking is an iOS discrete HTTP API calling framework based on AFNetworking,this is CTNetworking
                    DESC

  s.homepage     = "https://github.com/Corotata/RTNetworking"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author       = {"corotata" => "Corotata@qq.com"}
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://git.nya.pics/Ligo/LGNetworking.git", :tag => s.version.to_s }

  s.source_files  = "CTNetworking/CTNetworking/**/*.{h,m}"
  #s.public_header_files = "CTNetworking/CTNetworking/**/*.h"
  s.resource  = "CTNetworking/CTNetworking/**/*.plist"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/AFNetworking" }
  s.dependency "AFNetworking", "~> 3.1.0"

end
