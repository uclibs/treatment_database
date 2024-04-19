# frozen_string_literal: true

require 'net/http'
require 'uri'

module PDFDownloadHelpers
  def verify_pdf_link_response(link_text)
    link = find_link(link_text)
    uri = URI(link[:href])

    response = fetch_response(uri)

    log_response_details(response) if response.code != '200'

    expect(response.code).to eq('200')
  end

  private

  # Handles all redirects and fetches the final response
  def fetch_response(uri)
    response = Net::HTTP.get_response(uri)
    while response.is_a?(Net::HTTPRedirection)
      uri = URI(response['location'])
      response = Net::HTTP.get_response(uri)
    end
    response
  end

  # Logs response details if not 200 OK
  def log_response_details(response)
    puts "Accessing URL: #{response.uri}"
    puts 'Unexpected response body for debugging:'
    puts response.body[0..2000] # Print the first 2000 characters of the body for deeper insight
  end
end
