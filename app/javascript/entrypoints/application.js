// ES6 imports
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import Turbolinks from "turbolinks";
import $ from 'jquery';
window.$ = window.jQuery = $;
import 'bootstrap';

Rails.start();
ActiveStorage.start();
Turbolinks.start();

// Example of importing custom scripts, adjust the path as necessary
// import './path/to/custom_script';
