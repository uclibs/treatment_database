# frozen_string_literal: true

module PDFDownloadHelper
  def check_pdf_link(link_text)
    ensure_link_with_text_exists(link_text)
    modify_link_target_to_self(link_text)
    click_and_check_errors(link_text)
    check_for_severe_browser_logs
  end

  private

  def ensure_link_with_text_exists(link_text)
    expect(page).to have_link(link_text)
    @link = find_link(link_text)
    @href = @link[:href].strip
    expect(@link[:target]).to eq '_blank'
    expect(@href).to include '/conservation_records/'
  end

  def modify_link_target_to_self(link_text)
    script = <<-JS
    var links = document.querySelectorAll('a');
    links.forEach(function(link) {
      if (link.textContent.trim() === '#{link_text.strip}' && link.getAttribute('href') === '#{@href}') {
        link.setAttribute('target', '_self');
      }
    });
    JS
    page.execute_script(script)
  end

  def click_and_check_errors(link_text)
    click_link(link_text)
    expect(page).not_to have_text('Error')
    expect(page).not_to have_text('Page not found')
    expect(page).not_to have_text('Something went wrong')
  end

  def check_for_severe_browser_logs
    logs = page.driver.browser.logs.get(:browser)
    severe_errors = logs.select { |log| log.level == 'SEVERE' && log.message }
    log_errors(severe_errors)
    expect(severe_errors).to be_empty, 'There are JavaScript errors on the page!'
  end

  def log_errors(errors)
    return unless errors.any?

    puts 'Severe browser logs detected:'
    errors.each { |error| puts error.message }
  end
end
