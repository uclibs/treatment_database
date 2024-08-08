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
    puts "Inside downlaod_and_verify_file"
    initial_file_count = downloaded_files.size
    puts "Initial file count: #{initial_file_count}"

    click_on button_text

    # Wait for the file to be downloaded, up to a maximum of 10 seconds
    max_wait_time = 10
    start_time = Time.now

    until downloaded_files.size > initial_file_count || Time.now - start_time > max_wait_time
      sleep 0.1
    end

    new_file_count = downloaded_files.size
    puts "New file count: #{new_file_count}"
    expect(new_file_count).to eq(initial_file_count + 1)
    expect(File.size(downloaded_files.last)).to be > 0
  end
end
