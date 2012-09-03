ActionController::Routing::Routes.draw do |map|
  # Homepage URL in specified language.
  # The 'lang' parameter will set to 'en_US' as default.
  map.homepage ':lang', :controller => 'static_pages', :action => 'index', :defaults => { :lang => 'en_US' }, :requirements => { :lang => /[a-z]{2}_[A-Z]{2}/}
  map.connect 'store', :controller => "store",:action => "index"
  
  map.connect 'store/:id', :controller => 'store', :action => 'product_detail', :requirements => { :id => /^[0-9\-\.]+\w*$/ }
  map.connect 'event/:id', :controller => 'event', :action => 'index', :requirements => { :id => /[0-9]/ }
  # Administrator entries of Substruct.
  map.connect 'admin', :controller => 'accounts', :action => 'login'
  
  # Show products in categories.
  map.connect '/store/tags/*tags', :controller => 'store', :action => 'tags'
  
  map.connect 'zh_CN/store/tags/*tags', :controller => 'store', :action => 'tags', :language => 'zh_CN'

  map.connect 'zh_CN/store/:id', :controller => 'store', :action => 'product_detail', :language => 'zh_CN'

  map.connect 'zh_HK/store/:id', :controller => 'store', :action => 'product_detail', :language => 'zh_HK'
  map.connect 'zh_TW/store/:id', :controller => 'store', :action => 'product_detail', :language => 'zh_TW'

  map.connect '/redray', :controller => 'nab', :action => 'index'
  
  # Routes for static pages
  $STATIC_PAGES = Dir.glob(RAILS_ROOT + '/app/views/static_pages/*.rhtml').collect do |file_name|
    File.basename(file_name).sub(/\.\w*$/, '')
  end
  $STATIC_PAGES.each do |action|
    map.send action, ":lang/#{action}", :controller => 'static_pages', :action => action, :requirements => { :lang => /[a-z]{2}_[A-Z]{2}/ }
    map.connect action, :controller => 'static_pages', :action => action, :defaults => { :lang => 'en_US' }
  end
  
  # Routes for reseting password.
  # NOTE:
  # While sending a reset password email via PostFix or other mail server, the content will be wrapped
  #   if current line is longer than a specified size.
  # Giving a short link in mail content to avoid this.
  map.connect 'reset_pwd/:token', :controller => 'account', :action => 'reset_password', :lang => 'en_US'
  map.connect ':lang/reset_pwd/:token', :controller => 'account', :action => 'reset_password', :requirements => { :lang => /[a-z]{2}_[A-Z]{2}/ }
  
  # Routing for special download page of "Final Cut Studio Plugin"
  map.connect 'apple', :controller => 'support', :action => 'apple'
  map.connect ':lang/apple', :controller => 'support', :action => 'apple', :requirements => { :lang => /[a-z]{2}_[A-Z]{2}/ }
  
  # Default routing rules below.
  # ALL specified rule should be placed above this block.
  map.connect ':controller/:action/:id', :lang => 'en_US'
  map.connect ':lang/:controller/:action/:id', :requirements => { :lang => /[a-z]{2}_[A-Z]{2}/ }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action'
end
