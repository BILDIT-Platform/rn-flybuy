import React from 'react';
import {SafeAreaView, ScrollView, useColorScheme} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';
import {CustomerSection} from './CustomerSection';
import {SitesSection} from './SitesSection';
import {OrdersSection} from './OrdersSection';

function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <CustomerSection />
        <SitesSection />
        <OrdersSection />
      </ScrollView>
    </SafeAreaView>
  );
}

export default App;
