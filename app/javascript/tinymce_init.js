import tinymce from 'tinymce';

// Initialize TinyMCE on your textarea
document.addEventListener('DOMContentLoaded', function() {
    tinymce.init({
        selector: '#tinymce-editor',
        theme: 'silver',
        plugins: ['link'],
        menubar: 'insert',
        toolbar: 'undo redo | formatselect | bold italic backcolor | \
             alignleft aligncenter alignright alignjustify | \
             bullist numlist outdent indent | link | removeformat | help',
        default_link_target: '_blank',
        base_url: '/tinymce',
        suffix: '.min', // Ensure to use minified versions of the files if available
    });
});
