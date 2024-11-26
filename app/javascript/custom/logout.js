document.addEventListener('turbolinks:load', () => {
    const logoutButton = document.getElementById('logout-button');
    if (logoutButton) {
        logoutButton.addEventListener('click', (event) => {
            event.preventDefault();

            // Send DELETE request to Rails logout path
            fetch(logoutButton.getAttribute('formaction'), {
                method: 'DELETE',
                headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content }
            })
                .then(response => response.json())
                .then(data => {
                    // Send GET request to Shibboleth logout URL in the background
                    fetch(data.shibboleth_logout_url, { method: 'GET', mode: 'no-cors' })
                        .catch(error => {
                            console.error('Shibboleth logout failed:', error);
                        });

                    // Redirect the user to the home page
                    window.location.href = '/';
                })
                .catch(error => {
                    console.error('Logout request failed:', error);
                });
        });
    }
});
