# @bildit-platform/rn-flybuy-core

React Native wrapper for FlyBuy Core SDK

## Installation

```sh
npm install @bildit-platform/rn-flybuy-core

cd ios && pod install
```

## Configuration

### Android

1. Modify `android/build.gradle`

  ```
    buildscript {
      ext {
          buildToolsVersion = "34.0.0"
          minSdkVersion = 26 // <-- the minimum supported SDK for the latest FlyBuy SDK
          compileSdkVersion = 34
          targetSdkVersion = 34
          ndkVersion = "26.1.10909125"
          kotlinVersion = "1.9.22"
          flybuyVersion = "2.12.1" // <-- add this line
      }
    }

  ```

  Note: Modify `flybuyVersion` with your desired SDK version, the default value is `2.12.1`

2. Modify `android/app/build.gradle`

  ```
     {
        android {
          defaultConfig {
            applicationId "your.package.name"
            minSdkVersion rootProject.ext.minSdkVersion
            targetSdkVersion rootProject.ext.targetSdkVersion
            versionCode 1
            versionName "1.0"

            missingDimensionStrategy "flybuy", "default" // <-- add this line
          }
        }
     }
  ```

### iOS

No specific configuration for iOS


## Usage


```js
import * as FlyBuyCore from '@bildit-platform/rn-flybuy-core';

// ...

const result = await FlyBuyCore.login('username@gmail.com', 'password');
```

## Migration from version 2.x to 3.0

Version 2.x

```js
  import FlyBuy from 'react-native-bildit-flybuy';

  FlyBuy.Core.Orders.fetchOrders()
      .then(orders => console.tron.log('orders', orders))
      .catch(err => console.tron.log(err));
```

Version 3.0

```js
  import * as FlyBuyCore from '@bildit-platform/rn-flybuy-core';

  FlyBuyCore.fetchOrders()
      .then(orders => console.tron.log('orders', orders))
      .catch(err => console.tron.log(err));
```


## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)


