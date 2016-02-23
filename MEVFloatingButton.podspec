#
# Be sure to run `pod lib lint MEVFloatingButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MEVFloatingButton"
  s.version          = "0.1.0"
  s.summary          = "An iOS drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a customizable floating button on top of it."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC 
  
  An iOS drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a customizable floating button on top of it. 
  A very customazible category in order to add a floating button as seen as in material design on top of a UIScrollView, UITableView or a UICollectionView.
  Includes different delegate methods such us 'didTapButton', 'floatingButtonWillAppear', 'floatingButtonDidAppear', 'floatingButtonWillDisappear' and 'floatingButtonDidDisappear'.
  
                       DESC

  s.homepage         = "https://github.com/manuelescrig/MEVFloatingButton"
  # s.screenshots     = "https://cloud.githubusercontent.com/assets/1849990/13219261/29aef4a8-d96f-11e5-8632-85b31c3c1c1f.gif", "https://cloud.githubusercontent.com/assets/1849990/13219263/29d8c3b4-d96f-11e5-9d12-502363e77759.gif", "https://cloud.githubusercontent.com/assets/1849990/13219262/29d78f94-d96f-11e5-8d01-0805ef799160.gif", "https://cloud.githubusercontent.com/assets/1849990/13219329/9efde354-d96f-11e5-88a5-4175729e471e.gif"
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
