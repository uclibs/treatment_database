# frozen_string_literal: true

# Axe is a tool that checks for accessibility violations in web pages. This helper
# provides a method to run Axe on a specific element or the whole page and check for
# accessibility violations.
module AxeHelper
  def check_accessibility_within(selector = nil)
    # Inject the Axe-core JavaScript into the page
    axe_script = File.read(Rails.root.join('node_modules/axe-core/axe.js').to_s)
    page.execute_script(axe_script)

    # Run Axe on the specific element or the whole page
    script = selector ? "axe.run('#{selector}')" : 'axe.run()'
    results = page.evaluate_script(script)

    # Check for accessibility violations
    expect(results['violations']).to be_empty, -> { "Accessibility violations: #{results['violations'].to_json}" }
  end
end
