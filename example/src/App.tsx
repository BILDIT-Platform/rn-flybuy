/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {SafeAreaView, ScrollView, useColorScheme} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';
import {Button} from './components';
import * as FlyBuyCore from '@bildit-platform/rn-flybuy-core';

function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  const login = () => {
    FlyBuyCore.login('ha_zellat@esi.dz', 'password')
      .then(customer => console.log(customer))
      // .then(customer => console.tron.log('customer', customer))
      .catch(err => console.error(err));
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Button title="Login" onPress={login} />
      </ScrollView>
    </SafeAreaView>
  );
}

export default App;
