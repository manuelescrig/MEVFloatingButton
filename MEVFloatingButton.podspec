#
# Be sure to run `pod lib lint MEVFloatingButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MEVFloatingButton"
  s.version          = "1.2"
  s.summary          = "An iOS drop-in UITableView, UICollectionView, UIScrollView superclass category for showing a customizable floating button on top of it."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC 
  
  A very customazible category in order to add a floating button as seen as in material design on top of a UIScrollView, UITableView or a UICollectionView.
                       DESC

  s.homepage         = "https://github.com/manuelescrig/MEVFloatingButton"
  # s.screenshots    = "https://cloud.githubusercontent.com/assets/1849990/13462466/db001be6-e087-11e5-92a1-79c8ecefb715.gif"
  s.license          = 'MIT'
  s.author           = { "Manuel Escrig Ventura" => "manuelescrig@gmail.com" }
  s.source           = { :git => "https://github.com/manuelescrig/MEVFloatingButton.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/manuelescrig'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MEVFloatingButton' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
