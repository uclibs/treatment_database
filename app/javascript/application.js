// Rails functionalities
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";

// Turbolinks
import Turbolinks from "turbolinks";

// External libraries
import "jquery";
import "popper.js";
import "bootstrap";

// Trix editor and ActionText
import "trix";
import "@rails/actiontext";
import "./stylesheets/application.scss";

// Start Rails UJS and Active Storage
Rails.start();
ActiveStorage.start();
Turbolinks.start();

// If you have other scripts or modules, import them here
// import "./another_script";
// You might also directly include certain scripts here, but organizing them into modules and importing is cleaner
