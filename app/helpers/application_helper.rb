# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{h(@title)}"  
    end  
  end  
  
  def logo
    return image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
  
  
  
  
end
