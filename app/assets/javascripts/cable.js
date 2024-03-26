// Import Action Cable's JavaScript directly
import { createConsumer } from "@rails/actioncable"

// Setup the global App variable if it doesn't exist
window.App ||= {};

// Assign the consumer to the App namespace
App.cable = createConsumer();

// If you have channel JavaScript files under app/javascript/channels,
// you can import them here as well
// For example, if you have a file app/javascript/channels/chat_channel.js,
// import it using:
// import "./channels/chat_channel"
