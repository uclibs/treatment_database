/**
 * Purpose:
 * This script handles logging out users from Shibboleth without redirecting them away from the application.
 * It ensures the user's session is cleared with Shibboleth and then redirects them back to the app.
 *
 * How it works:
 * - Sends a logout request to the app to clear the session.
 * - Creates an invisible iframe to log the user out of Shibboleth.
 * - Redirects the user back to the home page after the logout process is complete.
 */

document.addEventListener('turbolinks:load', () => {
    console.log('logout.js loaded');
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
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
                    'Accept': 'application/json'
                }
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    // Create an invisible iframe to load the Shibboleth logout URL
                    const iframe = document.createElement('iframe');
                    iframe.style.display = 'none';
                    iframe.src = data.shibboleth_logout_url;
                    document.body.appendChild(iframe);

                    // Redirect the user back to your app after a delay
                    setTimeout(() => {
                        window.location.href = '/treatment_database?logged_out=true';
                    }, 1000);
                })
                .catch(error => {
                    console.error('Logout request failed:', error);
                });
        });
    }
});
