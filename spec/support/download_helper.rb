# frozen_string_literal: true

module DownloadHelper
  DOWNLOAD_DIRECTORY = File.join(Dir.pwd, 'tmp', 'downloads')

  def setup_download_directory
    FileUtils.mkdir_p(DOWNLOAD_DIRECTORY) # Ensure the directory exists
    FileUtils.rm_rf(Dir.glob("#{DOWNLOAD_DIRECTORY}/*")) # Clean download directory
    expect(downloaded_files.size).to eq(0)
  end

  def download_directory
    DOWNLOAD_DIRECTORY
  end

  def downloaded_files
    Dir.glob("#{download_directory}/*.pdf")
  end

  def download_and_verify_file(button_text)
    expect(page).to have_content(button_text)
    initial_file_count = downloaded_files.size

    click_on button_text

    # Wait for the file to be downloaded, up to a maximum of 10 seconds
    max_wait_time = 10
    start_time = Time.zone.now

    while Time.zone.now - start_time < max_wait_time
      sleep 0.1
      new_file_count = downloaded_files.size
      break if new_file_count > initial_file_count
    end

    new_file_count = downloaded_files.size
    expect(new_file_count).to eq(initial_file_count + 1)
    expect(File.size(downloaded_files.last)).to be > 0
  end
end
