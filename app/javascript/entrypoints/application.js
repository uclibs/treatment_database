// ES6 imports
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import Turbolinks from "turbolinks";

Rails.start();
ActiveStorage.start();
Turbolinks.start();

import $ from 'jquery';
window.$ = window.jQuery = $;

import Popper from 'popper.js';
window.Popper = Popper;

import 'bootstrap'; // Needs to be imported after jquery and popper

// Example of importing custom scripts, adjust the path as necessary
// import './path/to/custom_script';
