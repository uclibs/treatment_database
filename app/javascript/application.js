// Import Rails libraries
import Rails from '@rails/ujs';
import * as ActiveStorage from '@rails/activestorage';
import Turbolinks from 'turbolinks';

Rails.start();
ActiveStorage.start();
Turbolinks.start();

// Import jQuery and other libraries
import jQuery from 'jquery';
window.jQuery = jQuery;
window.$ = jQuery;

// Import Popper
import Popper from 'popper.js';
window.Popper = Popper;

// Import Bootstrap JavaScript
import 'bootstrap';

// Import custom CSS
import './stylesheets/application.scss';

// Import all the images in the images file:
function importAll(r) {
    r.keys().forEach(r);
}
importAll(require.context('./images/', false, /\.(png|jpe?g|svg)$/));
