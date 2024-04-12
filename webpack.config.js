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
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            },
            {
                test: /\.(svg|eot|woff|woff2|ttf)$/,
                type: 'asset/resource'
            },
        ],
    },
};
