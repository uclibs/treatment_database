(function() {
    document.addEventListener('DOMContentLoaded', function () {
        if (!window.Stimulus) {
            window.Stimulus = Stimulus.Application.start();
        }

        // Ensure InHouseModalController is defined before trying to register it
        if (window.InHouseModalController) {
            window.Stimulus.register("in_house_modal", window.InHouseModalController);
        } else {
            console.error("InHouseModalController is not defined.");
        }
    });
})();

