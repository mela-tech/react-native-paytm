[![](https://badge.fury.io/js/%40philly25%2Freact-native-paytm.svg)](https://www.npmjs.com/package/@philly25/react-native-paytm)

# @philly25/react-native-paytm
This library has been forked from https://github.com/elanic-tech/react-native-paytm
Updated it to work with the latest version of react-native and latest PayTM SDK.

### installation

#### Android
````bash
react-native link @philly25/react-native-paytm
````

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules/@philly25/react-native-paytm` and add `RNPayTm.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPayTm.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)
      

## Usage

For more details check official documentation: [iOS](https://developer.paytm.com/docs/v1/ios-sdk/) and [Android](https://developer.paytm.com/docs/v1/android-sdk).

Example:

```javascript
import paytm from '@philly25/react-native-paytm';
import { Platform, DeviceEventEmitter, NativeModules, NativeEventEmitter } from 'react-native';

// Data received from PayTM
const paytmConfig = {
    MID: 'Value from PayTM dashboard',
    WEBSITE: 'Value from PayTM dashboard',
    CHANNEL_ID: 'WAP',
    INDUSTRY_TYPE_ID: 'Retail',
    CALLBACK_URL: 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID='
}

componentWillMount() {
    if (Platform.OS === 'ios') {
        const { RNPayTm } = NativeModules;
        const emitter = new NativeEventEmitter(RNPayTm);
        emitter.addListener('PayTMResponse', this.onPayTmResponse);
    } else {
        DeviceEventEmitter.addListener('PayTMResponse', this.onPayTmResponse);
    }	
}

componentWillUnmount() {
    if (Platform.OS === 'ios') {
        this.emitter.removeListener('PayTMResponse', this.onPayTmResponse);
    } else {
        DeviceEventEmitter.removeListener('PayTMResponse', this.onPayTmResponse);
    }
}

onPayTmResponse = (resp) => {
    const {STATUS, status, response} = resp;

    if (Platform.OS === 'ios') {
      if (status === 'Success') {
        const jsonResponse = JSON.parse(response);
        const {STATUS} = jsonResponse;

        if (STATUS && STATUS === 'TXN_SUCCESS') {
          // Payment succeed!
        }
      }
    } else {
      if (STATUS && STATUS === 'TXN_SUCCESS') {
        // Payment succeed!
      }
    }
  };

runTransaction(amount, customerId, orderId, mobile, email, checkSum) {
    const callbackUrl = `${paytmConfig.CALLBACK_URL}${orderId}`;
    const details = {
        mode: 'Staging', // 'Staging' or 'Production'
        MID: paytmConfig.MID,
        INDUSTRY_TYPE_ID: paytmConfig.INDUSTRY_TYPE_ID,
        WEBSITE: paytmConfig.WEBSITE,
        CHANNEL_ID: paytmConfig.CHANNEL_ID,
        TXN_AMOUNT: `${amount}`, // String
        ORDER_ID: orderId, // String
        EMAIL: email, // String
        MOBILE_NO: mobile, // String
        CUST_ID: customerId, // String
        CHECKSUMHASH: checkSum, //From your server using PayTM Checksum Utility 
        CALLBACK_URL: callbackUrl,
    };
    
    paytm.startPayment(details);
}
```
  
