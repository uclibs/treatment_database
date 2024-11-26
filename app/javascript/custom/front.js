/**
 * Purpose:
 * This script removes the "logged_out=true" query parameter from the URL after the user has successfully logged out.
 * It ensures that users don't see the logout message again if they refresh the page or bookmark the URL.
 *
 * How it works:
 * - Checks if the URL contains the "logged_out=true" parameter.
 * - Cleans up the URL by removing the parameter without refreshing the page.
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('front.js loaded');
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('logged_out')) {
        // Remove the query parameter from the URL
        const newUrl = window.location.origin + window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
    }
});
