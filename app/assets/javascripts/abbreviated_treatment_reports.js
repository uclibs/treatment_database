$(document).on('turbolinks:load', function() {
    $('#saveAbbreviatedTreatmentReport').on('click', function(e) {
        e.preventDefault();

        // Extract the ConservationRecord ID from the URL
        var pathArray = window.location.pathname.split('/');
        var conservationRecordIdIndex = pathArray.indexOf("conservation_records") + 1;
        var conservationRecordId = pathArray[conservationRecordIdIndex];

        // Check if the ConservationRecord ID was successfully retrieved
        if (!conservationRecordId || isNaN(conservationRecordId)) {
            alert("Failed to identify the Conservation Record ID from the URL.");
            return; // Exit the function if no valid ID is found
        }

        // Construct the URL for the AJAX request
        var url = `/conservation_records/${conservationRecordId}/create_or_update_abbreviated_treatment_report`;

        var form = $('#abbreviatedTreatmentReportForm');
        var formData = form.serialize();

        $.ajax({
            type: "POST",
            url: url,
            data: formData,
            dataType: "json",
            success: function(data) {
                $('#successMessage').text('Abbreviated Treatment Report saved successfully.').show();
                setTimeout(function() { $('#successMessage').fadeOut('slow'); }, 4000);
                $('#errorMessages').hide().empty();
            },
            error: function(xhr, status, error) {
                // General AJAX error (e.g., server issues, network errors)
                if (!xhr.responseJSON) {
                    $('#errorMessages').html('<p>An unexpected error occurred. Please try again later.</p>').show();
                } else {
                    // Handle validation or other errors returned by the server
                    var errors = xhr.responseJSON;
                    var errorMessages = '';
                    for (var key in errors) {
                        if (errors.hasOwnProperty(key)) {
                            errors[key].forEach(function(error) {
                                errorMessages += '<p>' + error + '</p>';
                            });
                        }
                    }
                    $('#errorMessages').html(errorMessages).show();
                }
                $('#successMessage').hide();
            }
        });
    });
});