document.addEventListener('turbolinks:load', function() {
    const switchInput = document.getElementById('accountActiveSwitch');
    const switchLabel = document.getElementById('accountActiveLabel');

    function updateLabel() {
        if (!switchInput || !switchLabel) return;

        if (switchInput.checked) {
            switchLabel.textContent = 'Account Active';
        } else {
            switchLabel.textContent = 'Account Inactive';
        }
    }

    // Initial label update
    updateLabel();

    if (switchInput) {
        switchInput.addEventListener('change', function() {
            updateLabel();
        });
    }
});