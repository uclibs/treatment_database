const path = require('path');

module.exports = {
    mode: 'development',
    entry: path.resolve(__dirname, 'app/javascript/entrypoints/application.js'),
    output: {
        path: path.resolve(__dirname, 'app/assets/builds'),
        filename: 'application.js',
    },
    module: {
        rules: [
            {
                test: /\.scss$/,
                use: [
                    'style-loader',  // creates style nodes from JS strings
                    'css-loader',    // translates CSS into CommonJS
                    'sass-loader'    // compiles Sass to CSS
                ]
            },
            {
                test: /\.(svg|eot|woff|woff2|ttf)$/,
                type: 'asset/resource'
            },
        ],
    },
};
