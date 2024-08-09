# frozen_string_literal: true

module DownloadLinkHelper
  def verify_download_link(link_text)
    # Ensure the link is present
    expect(page).to have_link(link_text)

    # Capture the current URL before clicking the link
    original_url = current_url

    # Convert the link text to a corresponding path fragment
    path_fragment = link_text.sub('Download ', '').downcase.gsub(' ', '_')

    # Remove target="_blank" from all links so that they link open in the same tab
    execute_script("document.querySelectorAll('a[target=\"_blank\"]').forEach(function(el) { el.removeAttribute('target'); });")

    # Click the link, which now opens in the same tab
    click_link link_text

    # Build the expected URL pattern based on the modified path fragment
    expected_path_pattern = %r{/conservation_records/\d+/#{path_fragment}}

    # Verify the URL matches the expected path pattern
    expect(current_path).to match(expected_path_pattern)

    # Return to the original URL
    visit original_url
  end
end
