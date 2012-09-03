module Admin::DownloadsHelper
  
  def download_picture_link(download)
    unless download.disable
      image_tag download.picture_url
    else
      image_tag download.picture_url, :style => "opacity: 0.5;"
    end
  end
  
end