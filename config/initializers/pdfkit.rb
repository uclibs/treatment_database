PDFKit.configure do |config|
  unless Rails.env.development?
    config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf.sh'
  end

  config.default_options = {
    :page_size        => 'Letter',
    :print_media_type => true
  }
end