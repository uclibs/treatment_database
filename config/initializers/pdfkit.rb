# frozen_string_literal: true

PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf.sh'

  config.default_options = {
    page_size: 'A3',
    print_media_type: true,
    dpi: 96,
    'footer-right': 'Page [page]',
    'footer-font-size' => 8,
    'footer-left': '[date]'
  }
end
