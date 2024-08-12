# frozen_string_literal: true

module DownloadLinkHelper
  def verify_download_link(link_text)
    # Capture the current URL before interacting with the link
    original_url = current_url

    ensure_link_presence(link_text)
    ensure_link_has_blank_target(link_text)
    remove_blank_target_from_links
    click_and_verify_link(link_text)

    # Return to the original URL after verification
    visit original_url
  end

  private

  def ensure_link_presence(link_text)
    expect(page).to have_link(link_text)
  end

  def ensure_link_has_blank_target(link_text)
    link = find_link(link_text)
    expect(link[:target]).to eq('_blank')
  end

  def remove_blank_target_from_links
    execute_script("document.querySelectorAll('a[target=\"_blank\"]').forEach(function(el) { el.removeAttribute('target'); });")
  end

  def click_and_verify_link(link_text)
    click_link link_text
    verify_url_matches_pattern(link_text)
  end

  def verify_url_matches_pattern(link_text)
    path_fragment = link_text.sub('Download ', '').downcase.gsub(' ', '_')
    expected_path_pattern = %r{/conservation_records/\d+/#{path_fragment}}
    expect(current_path).to match(expected_path_pattern)
  end
end
