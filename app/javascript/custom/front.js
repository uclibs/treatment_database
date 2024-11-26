/**
 * Purpose:
 * This script removes the "logged_out=true" query parameter from the URL after the user has successfully logged out.
 * It ensures that users don't see the logout message again if they refresh the page or bookmark the URL.
 *
 * How it works:
 * - Checks if the URL contains the "logged_out=true" parameter.
 * - Displays a logout confirmation message if the parameter exists.
 * - Cleans up the URL by removing the parameter without refreshing the page.
 */

document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('logged_out')) {
        // Display the flash message
        const flashMessage = document.createElement('div');
        flashMessage.className = 'alert alert-notice';
        flashMessage.innerText = 'You have successfully signed out.';
        document.body.prepend(flashMessage);

        // Remove the query parameter from the URL
        const newUrl = window.location.origin + window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
    }
});
