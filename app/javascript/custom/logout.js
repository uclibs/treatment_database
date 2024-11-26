document.addEventListener('turbolinks:load', () => {
    const logoutButton = document.getElementById('logout-button');
    if (logoutButton) {
        logoutButton.addEventListener('click', (event) => {
            event.preventDefault();

            // Find the parent form and get its action attribute
            const form = logoutButton.closest('form');
            const logoutUrl = form ? form.getAttribute('action') : null;

            if (!logoutUrl) {
                console.error('Logout form action URL is missing.');
                return;
            }

            // Send DELETE request to Rails logout path
            fetch(logoutUrl, {
                method: 'DELETE',
                headers: {
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                }
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    return response.json();
                })
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
