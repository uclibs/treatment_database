// This manifest.js is part of our application's asset pipeline configuration.
// While we have migrated our JavaScript and CSS handling to Webpack (via jsbundling-rails)
// and cssbundling-rails for improved module management and modern JavaScript/CSS features,
// we continue to utilize Sprockets for managing static assets like images and fonts.
// This hybrid approach allows us to leverage the strengths of both Sprockets and Webpack:
// Sprockets for its simplicity and convention-based management of static assets, and
// Webpack for its advanced bundling capabilities for our script and style files.
// We believe this setup offers a balanced solution, providing both modern development practices
// for our scripts and styles, while maintaining a straightforward approach for static assets.
//
// As such, we use the Sprockets directive below to include all images located in app/assets/images
// for precompilation, ensuring they are available in production environments and leveraging
// Sprockets' cache busting and asset management features for these types of assets.
//
//= link_tree ../images
