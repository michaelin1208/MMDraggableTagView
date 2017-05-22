Pod::Spec.new do |s|

  s.name         = "MMDraggableTagView"
  s.version      = “0.0.1”
  s.summary      = "MMDraggableTagView is used to show draggable tags in a view”

  s.description  = <<-DESC
		MMDraggableTagView is used to show draggable tags in a view. 
                   DESC
  s.homepage     = "https://github.com/michaelin1208/MMDraggableTagView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "michaelin1208" => "michaelin1208@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/michaelin1208/MMDraggableTagView.git", :tag => "#{s.version}" }
  s.source_files  = "MMDraggableTagView", "MMDraggableTagView/**/*.{h,m}"
  s.framework    = "UIKit”,”SnapKit”
  s.requires_arc = true
end
