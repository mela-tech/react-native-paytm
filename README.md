![](https://badge.fury.io/js/%40philly25%2Freact-native-paytm.svg)

# react-native-paytm
This library has been forked from https://github.com/elanic-tech/react-native-paytm
Updated it to work with the latest version of react-native and latest PayTM SDK.

### installation

#### Android
````bash
react-native link react-native-paytm
````

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-paytm` and add `RNPayTm.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPayTm.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<
      

## Usage
```javascript
import paytm from 'react-native-paytm';
import { ..., Platform, DeviceEventEmitter, NativeModules, NativeEventEmitter, ... } from 'react-native';

...

// Daat received from PayTM
const paytmConfig = {
  MID: '...',
  WEBSITE: '...',
  CHANNEL_ID: '...',
  INDUSTRY_TYPE_ID: '...',
  CALLBACK_URL: 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID='
}

componentWillMount() {
    ...
	if (Platform.OS === 'ios') {
      const { RNPayTm } = NativeModules
      const emitter = new NativeEventEmitter(RNPayTm)
      emitter.addListener('PayTMResponse', this.onPayTmResponse)
    } else {
      DeviceEventEmitter.addListener('PayTMResponse', this.onPayTmResponse)
    }
    ...
}

onPayTmResponse(response) {
  // Process Response
  // response.response in case of iOS
  // reponse in case of Android
  console.log(response);
}

runTransaction(amount, customerId, orderId, mobile, email, checkSum, MERC_UNQ_REF) {
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
  
