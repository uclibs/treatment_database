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

                    // Optional: Remove the iframe after a delay
                    setTimeout(() => {
                        document.body.removeChild(iframe);
                    }, 5000);

                    // Redirect the user back to your app after a delay
                    setTimeout(() => {
                        window.location.href = '/treatment_database';
                    }, 1000);
                })
                .catch(error => {
                    console.error('Logout request failed:', error);
                });
        });
    }
});
