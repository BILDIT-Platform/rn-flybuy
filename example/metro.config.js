const {getDefaultConfig, mergeConfig} = require('@react-native/metro-config');
const path = require('path');
const fs = require('fs');
const watchFolders = [];
const extraNodeModules = {};
const nodeModulesPaths = [];
const toFollow = ['@bildit-platform/rn-flybuy-core'];

toFollow.forEach(name => {
  const realPath = fs.realpathSync(path.resolve('node_modules', name));
  watchFolders.push(realPath);
  extraNodeModules[name] = realPath;
  nodeModulesPaths.push(path.join(realPath, 'node_modules'));
});

/**
 * Metro configuration
 * https://reactnative.dev/docs/metro
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = {
  resolver: {
    extraNodeModules,
    nodeModulesPaths,
  },
  watchFolders,
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
