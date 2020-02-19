
package com.reactlibrary;

import android.app.Activity;
import javax.annotation.Nullable;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.paytm.pgsdk.PaytmOrder;
import com.paytm.pgsdk.PaytmPaymentTransactionCallback;
import com.paytm.pgsdk.TransactionManager;

public class RNPayTmModule extends ReactContextBaseJavaModule {

  private TransactionManager transactionManager;

  private final ReactApplicationContext reactContext;

  private static final int  REQUEST_CODE = 121;

  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
      if (requestCode == REQUEST_CODE && data != null) {
        WritableMap params = new WritableNativeMap();
        params.putString("status", data.getStringExtra("nativeSdkForMerchantMessage")  + data.getStringExtra("response"));
        sendEvent( "PayTMResponse", params);
      }
    }
  };

  public RNPayTmModule(ReactApplicationContext reactContext) {
    super(reactContext);
    reactContext.addActivityEventListener(mActivityEventListener);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNPayTm";
  }

  @ReactMethod
  public void startPayment(ReadableMap options) {

    PaytmOrder Order = new PaytmOrder(
            options.getString("orderId"),
            options.getString("mid"),
            options.getString("txnToken"),
            options.getString("amount"),
            options.getString("callbackUrl"));

    transactionManager = new TransactionManager(Order, new PaytmPaymentTransactionCallback() {
      @Override
      public void someUIErrorOccurred(String inErrorMessage) {
        Log.d("RNPayTm", "Some UI Error Occurred: " + inErrorMessage);
        WritableMap params = new WritableNativeMap();
        params.putString("status", "UIErrorOccurred");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void onTransactionResponse(Bundle inResponse) {
        Log.d("RNPayTm", "Payment Transaction Response: " + inResponse);
        WritableMap params = Arguments.fromBundle(inResponse);
        params.putString("status", "Success");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void networkNotAvailable() {
        Log.d("RNPayTm", "Network Not Available");
        WritableMap params = new WritableNativeMap();
        params.putString("status", "NetworkNotAvailable");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void clientAuthenticationFailed(String inErrorMessage) {
        Log.d("RNPayTm", "Client Authentication Failed: " + inErrorMessage);
        WritableMap params = new WritableNativeMap();
        params.putString("status", "ClientAuthenticationFailed");
        sendEvent( "PayTMResponse", params );
      }

      @Override
      public void onErrorLoadingWebPage(int iniErrorCode, String inErrorMessage, String inFailingUrl) {
        Log.d("RNPayTm", "Error Loading WebPage: " + inErrorMessage);
        WritableMap params = new WritableNativeMap();
        params.putString("status", "ErrorLoadingWebPage");
        sendEvent( "PayTMResponse", params );
      }

      // had to be added: NOTE
      @Override
      public void onBackPressedCancelTransaction() {
        Log.d("RNPayTm", "Transaction cancelled: BackPressedCancelTransaction");
        WritableMap params = new WritableNativeMap();
        params.putString("status", "Cancel");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void onTransactionCancel(String inErrorMessage, Bundle inResponse) {
        Log.d("RNPayTm", "Transaction cancelled: " + inErrorMessage);
        WritableMap params = Arguments.fromBundle(inResponse);
        params.putString("status", "Cancel");
        sendEvent( "PayTMResponse", params);
      }
    });
    transactionManager.startTransaction(getCurrentActivity(), REQUEST_CODE);

  }


  private void sendEvent(String eventName, @Nullable WritableMap params) {
  reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }

}
