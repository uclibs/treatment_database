const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { WebpackManifestPlugin } = require('webpack-manifest-plugin');

module.exports = (env, argv) => {
  const isProduction = argv.mode === 'production';
  const publicPath = `${process.env.RAILS_RELATIVE_URL_ROOT}/build/`;

  return {
    devtool: 'source-map',
    entry: {
      application: './app/javascript/application.js'
    },
    output: {
      path: path.resolve(__dirname, 'public', 'build'),
      publicPath: publicPath,
      filename: 'javascripts/[name]-[contenthash].js'
    },
    module: {
      rules: [
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, 'css-loader']
        },
        {
          test: /\.scss$/,
          use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader']
        },
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env']
            }
          }
        },
        {
          test: /\.(png|jpe?g|svg)$/i,
          use: [
            {
              loader: 'file-loader',
              options: {
                outputPath: 'assets/images/',
                publicPath: '/build/assets/images',
                name: '[name]-[hash].[ext]',
              },
            },
          ],
        },
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: 'stylesheets/[name]-[contenthash].css',
      }),
      new WebpackManifestPlugin({
        publicPath: '/build/',
        writeToFileEmit: true,
        generate: (seed, files) => {
          return files.reduce((manifest, file) => {
            const name = path.basename(file.name, path.extname(file.name));
            const ext = path.extname(file.name);
            manifest[name + ext] = file.path.replace(/^.*\/build\//, '');
            return manifest;
          }, seed);
        }
      })
    ],
  };
}
