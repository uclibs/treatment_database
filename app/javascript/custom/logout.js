document.addEventListener('turbolinks:load', () => {
    const logoutButton = document.getElementById('logout-button');
    if (logoutButton) {
        logoutButton.addEventListener('click', (event) => {
            event.preventDefault();

            const logoutUrl = logoutButton.dataset.logoutUrl; // Fetch logout URL from data attribute
            if (!logoutUrl) {
                console.error('Logout URL is missing.');
                return;
            }

            // Send DELETE request to Rails logout path
            fetch(logoutUrl, {
                method: 'DELETE',
                headers: {
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
                    'Accept': 'application/json',
                },
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    const iframe = document.createElement('iframe');
                    iframe.style.display = 'none';
                    iframe.src = data.shibboleth_logout_url;
                    document.body.appendChild(iframe);

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
