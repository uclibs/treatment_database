// See: https://stimulus.hotwired.dev/handbook/installing

(function(global) {
    // Define the controller class
    var InHouseModalController = Stimulus.Controller.extend({
        targets: ["performedByUserId", "repairType", "minutesSpent", "otherNote", "staffCodeId"],

        connect: function() {
            console.log("Modal controller connected!");
            console.log("Targets:", this.performedByUserIdTarget);
            console.log("Does performedByUserId target exist?", this.hasPerformedByUserIdTarget);  // True or False
        },

        populate: function(event) {
            event.preventDefault();

            var button = event.currentTarget;
            this.performedByUserIdTarget.value = button.getAttribute("data-user-id");
            this.repairTypeTarget.value = button.getAttribute("data-repair-type");
            this.minutesSpentTarget.value = button.getAttribute("data-minutes-spent");
            this.otherNoteTarget.value = button.getAttribute("data-other-note");
            this.staffCodeIdTarget.value = button.getAttribute("data-staff-code-id");

            console.log(performedByUserId, repairType, minutesSpent, otherNote, staffCodeId);
            $(this.modalTarget).modal('show');
        }
    });
    global.InHouseModalController = InHouseModalController;
})();
