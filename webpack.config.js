const path = require('path');

module.exports = {
    mode: 'development',
    entry: path.resolve(__dirname, 'app/javascript/entrypoints/application.js'),
    output: {
        path: path.resolve(__dirname, 'app/assets/builds'),
        filename: 'application.js',
    },
};
