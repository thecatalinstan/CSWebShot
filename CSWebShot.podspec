Pod::Spec.new do |s|

  s.name                        =  "CSWebShot"
  s.version                     =  "1.0.0"
  s.license                     =  "MIT"

  s.summary                     =  "A library for getting screenshots and rendered HTML source code of webpages."

  s.homepage                    =  "https://github.com/thecatalinstan/CSWebShot"
  s.author                      =   { "Cătălin Stan" => "catalin.stan@me.com" }
  s.social_media_url            =   "http://twitter.com/catalinstan"

  s.source                      =  { :git => "https://github.com/thecatalinstan/CSWebShot.git", :tag => s.version }

  s.module_name                 = "CSWebShot"

  s.source_files                = "CSWebShot/*.{h,m}"
  s.public_header_files         = "CSWebShot/CSWebShot.h"

  s.osx.deployment_target       = "10.7"
  s.osx.frameworks              = "Foundation"

  s.requires_arc                = true

end
