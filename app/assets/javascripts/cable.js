// Import Action Cable's JavaScript directly
import { createConsumer } from "@rails/actioncable"

// Setup the global App variable if it doesn't exist
window.App ||= {};

// Assign the consumer to the App namespace
App.cable = createConsumer();