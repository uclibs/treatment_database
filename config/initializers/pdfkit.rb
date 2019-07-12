# frozen_string_literal: true

PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf.sh'

  config.default_options = {
    page_size: 'Letter',
    print_media_type: true,
    dpi: 96
  }
end
