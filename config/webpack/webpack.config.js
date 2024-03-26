const path = require("path");
const webpack = require("webpack");
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
    mode: "production",
    devtool: "source-map",
    entry: {
        application: path.resolve(__dirname, '..', '..', 'app', 'javascript', 'application.js')
    },
    output: {
        filename: "[name].js",
        sourceMapFilename: "[file].map",
        path: path.resolve(__dirname, '..', '..', 'app/assets/builds')
    },
    module: {
        rules: [
            {
                test: /\.scss$/,
                use: [
                    // Use MiniCssExtractPlugin in production for separate CSS files
                    process.env.NODE_ENV !== 'production' ? 'style-loader' : MiniCssExtractPlugin.loader,
                    'css-loader', // Translates CSS into CommonJS
                    'sass-loader' // Compiles Sass to CSS
                ],
            },
        ],
    },
    plugins: [
        new webpack.optimize.LimitChunkCountPlugin({
            maxChunks: 1
        }),
        // Add the MiniCssExtractPlugin to your plugins
        new MiniCssExtractPlugin({
            filename: "[name].css",
        }),
    ]
};