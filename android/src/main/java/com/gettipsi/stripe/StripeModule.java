package com.gettipsi.stripe;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.text.TextUtils;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.gettipsi.stripe.util.ArgCheck;
import com.gettipsi.stripe.util.Converters;
import com.gettipsi.stripe.util.Fun0;
import com.google.android.gms.wallet.WalletConstants;
import com.stripe.android.Stripe;
import com.stripe.android.TokenCallback;
import com.stripe.android.model.PaymentMethod;
import com.stripe.android.model.PaymentMethodCreateParams;
import com.stripe.android.model.Source;
import com.stripe.android.model.Token;

import static com.gettipsi.stripe.Errors.*;
import static com.gettipsi.stripe.util.Converters.convertPaymentMethodToWritableMap;
import static com.gettipsi.stripe.util.Converters.convertSourceToWritableMap;
import static com.gettipsi.stripe.util.Converters.convertTokenToWritableMap;
//import static com.gettipsi.stripe.util.Converters.createBankAccount;
import static com.gettipsi.stripe.util.Converters.createCard;
import static com.gettipsi.stripe.util.Converters.createPaymentMethodCard;
import static com.gettipsi.stripe.util.InitializationOptions.ANDROID_PAY_MODE_KEY;
import static com.gettipsi.stripe.util.InitializationOptions.ANDROID_PAY_MODE_PRODUCTION;
import static com.gettipsi.stripe.util.InitializationOptions.ANDROID_PAY_MODE_TEST;
import static com.gettipsi.stripe.util.InitializationOptions.PUBLISHABLE_KEY;

public class StripeModule extends ReactContextBaseJavaModule {

  private static final String MODULE_NAME = StripeModule.class.getSimpleName();

  private static StripeModule sInstance = null;

  public static StripeModule getInstance() {
    return sInstance;
  }

  public Stripe getStripe() {
    return mStripe;
  }

  @Nullable
  private Promise mCreateSourcePromise;

  @Nullable
  private Source mCreatedSource;

  private String mPublicKey;
  private Stripe mStripe;
  private PayFlow mPayFlow;
  private ReadableMap mErrorCodes;

  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
      boolean handled = getPayFlow().onActivityResult(activity, requestCode, resultCode, data);
      if (!handled) {
        super.onActivityResult(activity, requestCode, resultCode, data);
      }
    }
  };


  public StripeModule(ReactApplicationContext reactContext) {
    super(reactContext);

    // Add the listener for `onActivityResult`
    reactContext.addActivityEventListener(mActivityEventListener);

    sInstance = this;
  }

  @Override
  public String getName() {
    return MODULE_NAME;
  }

  @ReactMethod
  public void init(@NonNull ReadableMap options, @NonNull ReadableMap errorCodes) {
    ArgCheck.nonNull(options);

    String newPubKey = Converters.getStringOrNull(options, PUBLISHABLE_KEY);
    String newAndroidPayMode = Converters.getStringOrNull(options, ANDROID_PAY_MODE_KEY);

    if (newPubKey != null && !TextUtils.equals(newPubKey, mPublicKey)) {
      ArgCheck.notEmptyString(newPubKey);

      mPublicKey = newPubKey;
      mStripe = new Stripe(getReactApplicationContext(), mPublicKey);
      getPayFlow().setPublishableKey(mPublicKey);
    }

    if (newAndroidPayMode != null) {
      ArgCheck.isTrue(ANDROID_PAY_MODE_TEST.equals(newAndroidPayMode) || ANDROID_PAY_MODE_PRODUCTION.equals(newAndroidPayMode));

      getPayFlow().setEnvironment(androidPayModeToEnvironment(newAndroidPayMode));
    }

    if (mErrorCodes == null) {
      mErrorCodes = errorCodes;
      getPayFlow().setErrorCodes(errorCodes);
    }
  }

  private PayFlow getPayFlow() {
    if (mPayFlow == null) {
      mPayFlow = PayFlow.create(
        new Fun0<Activity>() { public Activity call() {
          return getCurrentActivity();
        }}
      );
    }

    return mPayFlow;
  }

  private static int androidPayModeToEnvironment(@NonNull String androidPayMode) {
    ArgCheck.notEmptyString(androidPayMode);
    return ANDROID_PAY_MODE_TEST.equals(androidPayMode.toLowerCase()) ? WalletConstants.ENVIRONMENT_TEST : WalletConstants.ENVIRONMENT_PRODUCTION;
  }

  @ReactMethod
  public void deviceSupportsAndroidPay(final Promise promise) {
    getPayFlow().deviceSupportsAndroidPay(false, promise);
  }

  @ReactMethod
  public void canMakeAndroidPayPayments(final Promise promise) {
    getPayFlow().deviceSupportsAndroidPay(true, promise);
  }

  @ReactMethod
  public void createTokenWithCard(final ReadableMap cardData, final Promise promise) {
    try {
      ArgCheck.nonNull(mStripe);
      ArgCheck.notEmptyString(mPublicKey);

      mStripe.createToken(
        createCard(cardData),
        mPublicKey,
        new TokenCallback() {
          public void onSuccess(Token token) {
            promise.resolve(convertTokenToWritableMap(token));
          }
          public void onError(Exception error) {
            error.printStackTrace();
            promise.reject(toErrorCode(error), error.getMessage());
          }
        });
    } catch (Exception e) {
      promise.reject(toErrorCode(e), e.getMessage());
    }
  }

  @ReactMethod
  public void createPaymentMethodWithCard(final ReadableMap cardData, final Promise promise) {
      new AsyncTask<Void, Void, Void>() {
          @Override
          protected Void doInBackground(Void... voids) {
              ArgCheck.nonNull(mStripe);
              ArgCheck.notEmptyString(mPublicKey);

              try {
                  PaymentMethod paymentMethod = mStripe.createPaymentMethodSynchronous(
                          PaymentMethodCreateParams.create(createPaymentMethodCard(cardData), null),
                          mPublicKey);
                  promise.resolve(convertPaymentMethodToWritableMap(paymentMethod));
              } catch (Exception e) {
                  promise.reject(toErrorCode(e), e.getMessage());
              }

              return null;
          }
      }.execute();
  }

  void processRedirect(@Nullable Uri redirectData) {
    if (mCreatedSource == null || mCreateSourcePromise == null) {

      return;
    }

    if (redirectData == null) {

      mCreateSourcePromise.reject(
        getErrorCode(mErrorCodes, "redirectCancelled"),
        getDescription(mErrorCodes, "redirectCancelled")
      );
      mCreatedSource = null;
      mCreateSourcePromise = null;
      return;
    }

    final String clientSecret = redirectData.getQueryParameter("client_secret");
    if (!mCreatedSource.getClientSecret().equals(clientSecret)) {
      mCreateSourcePromise.reject(
        getErrorCode(mErrorCodes, "redirectNoSource"),
        getDescription(mErrorCodes, "redirectNoSource")
      );
      mCreatedSource = null;
      mCreateSourcePromise = null;
      return;
    }

    final String sourceId = redirectData.getQueryParameter("source");
    if (!mCreatedSource.getId().equals(sourceId)) {
      mCreateSourcePromise.reject(
        getErrorCode(mErrorCodes, "redirectWrongSourceId"),
        getDescription(mErrorCodes, "redirectWrongSourceId")
      );
      mCreatedSource = null;
      mCreateSourcePromise = null;
      return;
    }

    final Promise promise = mCreateSourcePromise;

    // Nulls those properties to avoid processing them twice
    mCreatedSource = null;
    mCreateSourcePromise = null;

    new AsyncTask<Void, Void, Void>() {
      @Override
      protected Void doInBackground(Void... voids) {
        Source source = null;
        try {
          source = mStripe.retrieveSourceSynchronous(sourceId, clientSecret);
        } catch (Exception e) {

          return null;
        }

        switch (source.getStatus()) {
          case Source.CHARGEABLE:
          case Source.CONSUMED:
            promise.resolve(convertSourceToWritableMap(source));
            break;
          case Source.CANCELED:
            promise.reject(
              getErrorCode(mErrorCodes, "redirectCancelled"),
              getDescription(mErrorCodes, "redirectCancelled")
            );
            break;
          case Source.PENDING:
          case Source.FAILED:
          case Source.UNKNOWN:
            promise.reject(
              getErrorCode(mErrorCodes, "redirectFailed"),
              getDescription(mErrorCodes, "redirectFailed")
            );
        }
        return null;
      }
    }.execute();
  }

}
