//
//  TPSStripeManager.m
//  TPSStripe
//
//  Created by Anton Petrov on 28.10.16.
//  Copyright © 2016 Tipsi. All rights reserved.
//

#import "TPSStripeManager.h"
#import <React/RCTUtils.h>
#import <React/RCTConvert.h>

#import "TPSError.h"
#import "RCTConvert+STPToken.h"
#import "RCTConvert+STPBankAccountHolderType.h"
#import "RCTConvert+STPBankAccountStatus.h"
#import "STPAPIClient+ApplePayWithPaymentMethod.h"
#import "RCTConvert+STPPaymentMethod.h"
#import "RCTConvert+STPPaymentMethodCardParams.h"
#import "RCTConvert+STPCardBrand.h"
#import "RCTConvert+STPCardFundingType.h"
#import "RCTConvert+STPCardParams.h"
#import "RCTConvert+STPSourceParams.h"
#import "RCTConvert+STPSource.h"

NSString * const kErrorKeyCode = @"errorCode";
NSString * const kErrorKeyDescription = @"description";
NSString * const kErrorKeyBusy = @"busy";
NSString * const kErrorKeyApi = @"api";
NSString * const kErrorKeyRedirectSpecific = @"redirectSpecific";
NSString * const kErrorKeyCancelled = @"cancelled";
NSString * const kErrorKeySourceStatusCanceled = @"sourceStatusCanceled";
NSString * const kErrorKeySourceStatusPending = @"sourceStatusPending";
NSString * const kErrorKeySourceStatusFailed = @"sourceStatusFailed";
NSString * const kErrorKeySourceStatusUnknown = @"sourceStatusUnknown";
NSString * const kErrorKeyDeviceNotSupportsNativePay = @"deviceNotSupportsNativePay";
NSString * const kErrorKeyNoPaymentRequest = @"noPaymentRequest";
NSString * const kErrorKeyNoMerchantIdentifier = @"noMerchantIdentifier";
NSString * const kErrorKeyNoAmount = @"noAmount";

NSString * const TPSPaymentNetworkAmex = @"american_express";
NSString * const TPSPaymentNetworkDiscover = @"discover";
NSString * const TPSPaymentNetworkMasterCard = @"master_card";
NSString * const TPSPaymentNetworkVisa = @"visa";

@implementation RCTConvert (PKContact)

+ (NSDictionary *)PKContactDictionary:(PKContact*)inputContact {
    NSMutableDictionary *contactDetails = [[NSMutableDictionary alloc] init];
    
    if (inputContact.name) {
        [contactDetails setValue:[NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:inputContact.name style:NSPersonNameComponentsFormatterStyleDefault options:0] forKey:@"name"];
    }
    
    if (inputContact.phoneNumber) {
        [contactDetails setValue:[inputContact.phoneNumber stringValue] forKey:@"phoneNumber"];
    }
    
    if (inputContact.emailAddress) {
        [contactDetails setValue:inputContact.emailAddress forKey:@"emailAddress"];
    }
    
    if (inputContact.supplementarySubLocality) {
        [contactDetails setValue:inputContact.supplementarySubLocality forKey:@"supplementarySubLocality"];
    }
    
    for (NSString *elem in @[@"street", @"city", @"state", @"country", @"ISOCountryCode", @"postalCode"]) {
        if ([inputContact.postalAddress respondsToSelector:NSSelectorFromString(elem)]) {
            [contactDetails setValue:[inputContact.postalAddress valueForKey:elem] forKey:elem];
        }
    }
    if ([contactDetails count] == 0) {
        return nil;
    }
    
    return contactDetails;
}

@end

@implementation RCTConvert (PKShippingMethod)

+ (NSDictionary *)PKShippingMethodDictionary:(PKShippingMethod*)inputShipping {
    NSMutableDictionary *shippingDetails = [[NSMutableDictionary alloc] init];
    
    if (inputShipping.label) {
        [shippingDetails setValue:inputShipping.label forKey:@"label"];
    }
    
    if (inputShipping.amount) {
        NSNumberFormatter* numberFormatter = [NSNumberFormatter new];
        [numberFormatter setPositiveFormat:@"$0.00"];
        [shippingDetails setValue:[numberFormatter stringFromNumber: inputShipping.amount] forKey:@"amount"];
    }
    
    if (inputShipping.detail) {
        [shippingDetails setValue:inputShipping.detail forKey:@"detail"];
    }
    
    if (inputShipping.identifier) {
        [shippingDetails setValue:inputShipping.identifier forKey:@"id"];
    }
    
    if ([shippingDetails count] == 0) {
        return nil;
    }
    
    return shippingDetails;
}

@end

@implementation RCTConvert (PKPaymentNetwork)

+ (PKPaymentNetwork)PKPaymentNetwork:(NSString *)paymentNetworkString {
    if ([paymentNetworkString isEqualToString:TPSPaymentNetworkAmex]) {
        return PKPaymentNetworkAmex;
    }
    if ([paymentNetworkString isEqualToString:TPSPaymentNetworkDiscover]) {
        return PKPaymentNetworkDiscover;
    }
    if ([paymentNetworkString isEqualToString:TPSPaymentNetworkMasterCard]) {
        return PKPaymentNetworkMasterCard;
    }
    if ([paymentNetworkString isEqualToString:TPSPaymentNetworkVisa]) {
        return PKPaymentNetworkVisa;
    }
    
    return nil;
}

@end

@implementation RCTConvert (PKAddressField)

+ (PKAddressField)PKAddressField:(NSString *)addressFieldString {
    PKAddressField addressField = PKAddressFieldNone;
    if ([addressFieldString isEqualToString:@"postal_address"]) {
        addressField = PKAddressFieldPostalAddress;
    }
    if ([addressFieldString isEqualToString:@"phone"]) {
        addressField = PKAddressFieldPhone;
    }
    if ([addressFieldString isEqualToString:@"email"]) {
        addressField = PKAddressFieldEmail;
    }
    if ([addressFieldString isEqualToString:@"name"]) {
        addressField = PKAddressFieldName;
    }
    if ([addressFieldString isEqualToString:@"all"]) {
        addressField = PKAddressFieldAll;
    }
    return addressField;
}

@end

@implementation RCTConvert (STPBillingAddressFields)

+ (STPBillingAddressFields)STPBillingAddressFields:(NSString*)inputType {
    if ([inputType isEqualToString:@"zip"]) {
        return STPBillingAddressFieldsZip;
    }
    if ([inputType isEqualToString:@"full"]) {
        return STPBillingAddressFieldsFull;
    }
    return STPBillingAddressFieldsNone;
}

@end

@implementation RCTConvert (STPAddress)

+ (STPAddress *)STPAddress:(NSDictionary*)inputAddress {
    STPAddress *address = [[STPAddress alloc] init];
    
    [address setName:inputAddress[@"name"]];
    [address setLine1:inputAddress[@"line1"]];
    [address setLine2:inputAddress[@"line2"]];
    [address setCity:inputAddress[@"city"]];
    [address setState:inputAddress[@"state"]];
    [address setPostalCode:inputAddress[@"postalCode"]];
    [address setCountry:inputAddress[@"country"]];
    [address setPhone:inputAddress[@"phone"]];
    [address setEmail:inputAddress[@"email"]];
    
    return address;
}
@end

@implementation RCTConvert (STPUserInformation)

+ (STPUserInformation *)STPUserInformation:(NSDictionary*)inputInformation {
    STPUserInformation *userInformation = [[STPUserInformation alloc] init];
    
    [userInformation setBillingAddress: [RCTConvert STPAddress:inputInformation[@"billingAddress"]]];
    [userInformation setShippingAddress: [RCTConvert STPAddress:inputInformation[@"shippingAddress"]]];
    
    return userInformation;
}

@end

@implementation RCTConvert (STPTheme)

+ (STPTheme *)STPTheme:(NSDictionary*)options {
    STPTheme *theme = [[STPTheme alloc] init];
    
    [theme setPrimaryBackgroundColor:[RCTConvert UIColor:options[@"primaryBackgroundColor"]]];
    [theme setSecondaryBackgroundColor:[RCTConvert UIColor:options[@"secondaryBackgroundColor"]]];
    [theme setPrimaryForegroundColor:[RCTConvert UIColor:options[@"primaryForegroundColor"]]];
    [theme setSecondaryForegroundColor:[RCTConvert UIColor:options[@"secondaryForegroundColor"]]];
    [theme setAccentColor:[RCTConvert UIColor:options[@"accentColor"]]];
    [theme setErrorColor:[RCTConvert UIColor:options[@"errorColor"]]];
    [theme setErrorColor:[RCTConvert UIColor:options[@"errorColor"]]];
    // TODO: process font vars
    
    return theme;
}
@end

@implementation RCTConvert (PKShippingType)

+ (PKShippingType)PKShippingType:(NSString*)inputType {
    PKShippingType shippingType = PKShippingTypeShipping;
    if ([inputType isEqualToString:@"delivery"]) {
        shippingType = PKShippingTypeDelivery;
    }
    if ([inputType isEqualToString:@"store_pickup"]) {
        shippingType = PKShippingTypeStorePickup;
    }
    if ([inputType isEqualToString:@"service_pickup"]) {
        shippingType = PKShippingTypeServicePickup;
    }
    
    return shippingType;
}

@end


@implementation StripeModule
{
    NSString *publishableKey;
    NSString *merchantId;
    NSDictionary *errorCodes;

    RCTPromiseResolveBlock promiseResolver;
    RCTPromiseRejectBlock promiseRejector;

    BOOL requestIsCompleted;

    void (^applePayCompletion)(PKPaymentAuthorizationStatus);
    NSError *applePayStripeError;
}

- (instancetype)init {
    if ((self = [super init])) {
        requestIsCompleted = YES;
    }
    return self;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (NSDictionary *)constantsToExport
{
    return @{@"TPSErrorDomain": TPSErrorDomain,
             @"TPSErrorCodeApplePayNotConfigured": [@(TPSErrorCodeApplePayNotConfigured) stringValue],
             @"TPSErrorCodePreviousRequestNotCompleted": [@(TPSErrorCodePreviousRequestNotCompleted) stringValue],
             @"TPSErrorCodeUserCancel": [@(TPSErrorCodeUserCancel) stringValue]};
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(init:(NSDictionary *)options errorCodes:(NSDictionary *)errors) {
    publishableKey = options[@"publishableKey"];
    merchantId = options[@"merchantId"];
    errorCodes = errors;
    [Stripe setDefaultPublishableKey:publishableKey];
}

RCT_EXPORT_METHOD(deviceSupportsApplePay:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    resolve(@([PKPaymentAuthorizationViewController canMakePayments]));
}

RCT_EXPORT_METHOD(canMakeApplePayPayments:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSArray <NSString *> *paymentNetworksStrings =
    options[@"networks"] ?: [StripeModule supportedPaymentNetworksStrings];

    NSArray <PKPaymentNetwork> *networks = [self paymentNetworks:paymentNetworksStrings];
    resolve(@([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:networks]));
}

RCT_EXPORT_METHOD(completeApplePayRequest:(RCTPromiseResolveBlock)resolve
                                    rejecter:(RCTPromiseRejectBlock)reject) {
    if (applePayCompletion) {
        promiseResolver = resolve;
        [self resolveApplePayCompletion:PKPaymentAuthorizationStatusSuccess];
    } else {
        resolve(nil);
    }
}

RCT_EXPORT_METHOD(cancelApplePayRequest:(RCTPromiseResolveBlock)resolve
                                rejecter:(RCTPromiseRejectBlock)reject) {
    if (applePayCompletion) {
        promiseResolver = resolve;
        [self resolveApplePayCompletion:PKPaymentAuthorizationStatusFailure];
    } else {
        resolve(nil);
    }
}

RCT_EXPORT_METHOD(createTokenWithCard:(NSDictionary *)params
                                resolver:(RCTPromiseResolveBlock)resolve
                                rejecter:(RCTPromiseRejectBlock)reject) {
    if(!requestIsCompleted) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyBusy];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return;
    }

    requestIsCompleted = NO;
    promiseResolver = resolve;
    promiseRejector = reject;

    STPCardParams *cardParams = [RCTConvert STPCardParams:params];

    STPAPIClient *stripeAPIClient = [self newAPIClient];

    [stripeAPIClient createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
        self->requestIsCompleted = YES;

        if (error) {
            NSDictionary *jsError = [self->errorCodes valueForKey:kErrorKeyApi];
            [self rejectPromiseWithCode:jsError[kErrorKeyCode] message:error.localizedDescription];
        } else {
            resolve([RCTConvert STPTokenDictionary:token]);
        }
    }];
}

RCT_EXPORT_METHOD(createPaymentMethodWithCard:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    if(!requestIsCompleted) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyBusy];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return;
    }

    requestIsCompleted = NO;
    promiseResolver = resolve;
    promiseRejector = reject;

    STPPaymentMethodCardParams *cardParams = [RCTConvert STPPaymentMethodCardParams:params];

    STPAPIClient *stripeAPIClient = [self newAPIClient];

    // Fill in card, billing details
    STPPaymentMethodParams *paymentMethodParams = [STPPaymentMethodParams paramsWithCard:cardParams billingDetails:nil metadata:nil];

    [stripeAPIClient createPaymentMethodWithParams:paymentMethodParams completion:^(STPPaymentMethod *paymentMethod, NSError *error) {
        self->requestIsCompleted = YES;

        if (error) {
            NSDictionary *jsError = [self->errorCodes valueForKey:kErrorKeyApi];
            [self rejectPromiseWithCode:jsError[kErrorKeyCode] message:error.localizedDescription];
        } else {
            resolve([RCTConvert STPPaymentMethodDictionary:paymentMethod]);
        }
    }];
}

RCT_EXPORT_METHOD(createTokenWithBankAccount:(NSDictionary *)params
                    resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject) {
    if(!requestIsCompleted) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyBusy];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return;
    }

    requestIsCompleted = NO;
    promiseResolver = resolve;
    promiseRejector = reject;

    STPBankAccountParams *bankAccount = [[STPBankAccountParams alloc] init];

    [bankAccount setAccountNumber: params[@"accountNumber"]];
    [bankAccount setCountry: params[@"countryCode"]];
    [bankAccount setCurrency: params[@"currency"]];
    [bankAccount setRoutingNumber: params[@"routingNumber"]];
    [bankAccount setAccountHolderName: params[@"accountHolderName"]];
    STPBankAccountHolderType accountHolderType =
    [RCTConvert STPBankAccountHolderType:params[@"accountHolderType"]];
    [bankAccount setAccountHolderType: accountHolderType];

    STPAPIClient *stripeAPIClient = [self newAPIClient];

    [stripeAPIClient createTokenWithBankAccount:bankAccount completion:^(STPToken *token, NSError *error) {
        self->requestIsCompleted = YES;

        if (error) {
            NSDictionary *jsError = [self->errorCodes valueForKey:kErrorKeyApi];
            [self rejectPromiseWithCode:jsError[kErrorKeyCode] message:error.localizedDescription];
        } else {
            resolve([RCTConvert STPTokenDictionary:token]);
        }
    }];
}

RCT_EXPORT_METHOD(createSourceWithParams:(NSDictionary *)params
                    resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject) {
    if(!requestIsCompleted) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyBusy];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return;
    }

    requestIsCompleted = NO;

    STPSourceParams* sourceParams = [RCTConvert STPSourceParams:params];
    STPAPIClient* stripeAPIClient = [self newAPIClient];

    [stripeAPIClient createSourceWithParams:sourceParams completion:^(STPSource *source, NSError *error) {
        self->requestIsCompleted = YES;

        if (error) {
            NSDictionary *jsError = [self->errorCodes valueForKey:kErrorKeyApi];
            reject(jsError[kErrorKeyCode], error.localizedDescription, nil);
        } else {
            if (source.redirect) {
                self.redirectContext = [[STPRedirectContext alloc] initWithSource:source completion:^(NSString *sourceID, NSString *clientSecret, NSError *error) {
                    if (error) {
                        NSDictionary *jsError = [self->errorCodes valueForKey:kErrorKeyRedirectSpecific];
                        reject(jsError[kErrorKeyCode], error.localizedDescription, nil);
                    } else {
                        [stripeAPIClient startPollingSourceWithId:sourceID clientSecret:clientSecret timeout:10 completion:^(STPSource *source, NSError *error) {
                            if (error) {
                                NSDictionary *jsError = [self->errorCodes valueForKey:kErrorKeyApi];
                                reject(jsError[kErrorKeyCode], error.localizedDescription, nil);
                            } else {
                                switch (source.status) {
                                    case STPSourceStatusChargeable:
                                    case STPSourceStatusConsumed:
                                        resolve([RCTConvert STPSourceDictionary:source]);
                                        break;
                                    case STPSourceStatusCanceled: {
                                        NSDictionary *error = [self->errorCodes valueForKey:kErrorKeySourceStatusCanceled];
                                        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
                                    }
                                        break;
                                    case STPSourceStatusPending: {
                                        NSDictionary *error = [self->errorCodes valueForKey:kErrorKeySourceStatusPending];
                                        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
                                    }
                                        break;
                                    case STPSourceStatusFailed: {
                                        NSDictionary *error = [self->errorCodes valueForKey:kErrorKeySourceStatusFailed];
                                        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
                                    }
                                        break;
                                    case STPSourceStatusUnknown: {
                                        NSDictionary *error = [self->errorCodes valueForKey:kErrorKeySourceStatusUnknown];
                                        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
                                    }
                                        break;
                                }
                            }
                        }];
                    }
                }];
                [self.redirectContext startSafariAppRedirectFlow];
            } else {
                resolve([RCTConvert STPSourceDictionary:source]);
            }
        }
    }];
}

//RCT_EXPORT_METHOD(paymentRequestWithCardForm:(NSDictionary *)options
//                                    resolver:(RCTPromiseResolveBlock)resolve
//                                    rejecter:(RCTPromiseRejectBlock)reject) {
//    if(!requestIsCompleted) {
//        NSDictionary *error = [errorCodes valueForKey:kErrorKeyBusy];
//        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
//        return;
//    }
//
//    requestIsCompleted = NO;
//    // Save promise handlers to use in `paymentAuthorizationViewController`
//    promiseResolver = resolve;
//    promiseRejector = reject;
//
//    STPBillingAddressFields requiredBillingAddressFields = [RCTConvert STPBillingAddressFields:options[@"requiredBillingAddressFields"]];
//    NSString *companyName = options[@"companyName"] ? options[@"companyName"] : @"";
//    STPUserInformation *prefilledInformation = [RCTConvert STPUserInformation:options[@"prefilledInformation"]];
//    NSString *managedAccountCurrency = options[@"managedAccountCurrency"];
//    NSString *nextPublishableKey = options[@"publishableKey"] ? options[@"publishableKey"] : publishableKey;
//    UIModalPresentationStyle formPresentation = [self formPresentation:options[@"presentation"]];
//    STPTheme *theme = [RCTConvert STPTheme:options[@"theme"]];
//
//    STPPaymentConfiguration *configuration = [[STPPaymentConfiguration alloc] init];
//    [configuration setRequiredBillingAddressFields:requiredBillingAddressFields];
//    [configuration setCompanyName:companyName];
//    [configuration setPublishableKey:nextPublishableKey];
//    [configuration setCreateCardSources:options[@"createCardSource"] ? options[@"createCardSource"] : false];
//
//    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] initWithConfiguration:configuration theme:theme];
//    [addCardViewController setDelegate:self];
//    [addCardViewController setPrefilledInformation:prefilledInformation];
//    [addCardViewController setManagedAccountCurrency:managedAccountCurrency];
//    // STPAddCardViewController must be shown inside a UINavigationController.
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
//    [navigationController setModalPresentationStyle:formPresentation];
//    navigationController.navigationBar.stp_theme = theme;
//    // move to the end of main queue
//    // allow the execution of hiding modal
//    // to be finished first
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [RCTPresentedViewController() presentViewController:navigationController animated:YES completion:nil];
//    });
//}

RCT_EXPORT_METHOD(paymentRequestWithApplePay:(NSArray *)items
                                    withOptions:(NSDictionary *)options
                                    resolver:(RCTPromiseResolveBlock)resolve
                                    rejecter:(RCTPromiseRejectBlock)reject) {
    if(!requestIsCompleted) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyBusy];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return;
    }

    requestIsCompleted = NO;
    // Save promise handlers to use in `paymentAuthorizationViewController`
    promiseResolver = resolve;
    promiseRejector = reject;

    NSUInteger requiredShippingAddressFields = [self applePayAddressFields:options[@"requiredShippingAddressFields"]];
    NSUInteger requiredBillingAddressFields = [self applePayAddressFields:options[@"requiredBillingAddressFields"]];
    PKShippingType shippingType = [RCTConvert PKShippingType:options[@"shippingType"]];
    NSMutableArray *shippingMethodsItems = options[@"shippingMethods"] ? options[@"shippingMethods"] : [NSMutableArray array];
    NSString* currencyCode = options[@"currencyCode"] ? options[@"currencyCode"] : @"USD";
    NSString* countryCode = options[@"countryCode"] ? options[@"countryCode"] : @"US";

    NSMutableArray *shippingMethods = [NSMutableArray array];

    for (NSDictionary *item in shippingMethodsItems) {
        PKShippingMethod *shippingItem = [[PKShippingMethod alloc] init];
        shippingItem.label = item[@"label"];
        shippingItem.detail = item[@"detail"];
        shippingItem.amount = [NSDecimalNumber decimalNumberWithString:item[@"amount"]];
        shippingItem.identifier = item[@"id"];
        [shippingMethods addObject:shippingItem];
    }

    NSMutableArray *summaryItems = [NSMutableArray array];

    for (NSDictionary *item in items) {
        PKPaymentSummaryItem *summaryItem = [[PKPaymentSummaryItem alloc] init];
        summaryItem.label = item[@"label"];
        summaryItem.amount = [NSDecimalNumber decimalNumberWithString:item[@"amount"]];
        summaryItem.type = [@"pending" isEqualToString:item[@"type"]] ? PKPaymentSummaryItemTypePending : PKPaymentSummaryItemTypeFinal;
        [summaryItems addObject:summaryItem];
    }

    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantId country:countryCode currency:currencyCode];

    [paymentRequest setRequiredShippingAddressFields:requiredShippingAddressFields];
    [paymentRequest setRequiredBillingAddressFields:requiredBillingAddressFields];
    [paymentRequest setPaymentSummaryItems:summaryItems];
    [paymentRequest setShippingMethods:shippingMethods];
    [paymentRequest setShippingType:shippingType];

    if ([self canSubmitPaymentRequest:paymentRequest rejecter:reject]) {
        PKPaymentAuthorizationViewController *paymentAuthorizationVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
        paymentAuthorizationVC.delegate = self;

        // move to the end of main queue
        // allow the execution of hiding modal
        // to be finished first
        dispatch_async(dispatch_get_main_queue(), ^{
            [RCTPresentedViewController() presentViewController:paymentAuthorizationVC animated:YES completion:nil];
        });
    } else {
        // There is a problem with your Apple Pay configuration.
        [self resetPromiseCallbacks];
        requestIsCompleted = YES;
    }
}

RCT_EXPORT_METHOD(openApplePaySetup) {
    PKPassLibrary *library = [[PKPassLibrary alloc] init];

    // Here we should check, if openPaymentSetup selector exist
    if ([library respondsToSelector:NSSelectorFromString(@"openPaymentSetup")]) {
        [library openPaymentSetup];
    }
}

#pragma mark - Private

- (void)resolvePromise:(id)result {
    if (promiseResolver) {
        promiseResolver(result);
    }
    [self resetPromiseCallbacks];
}

- (void)rejectPromiseWithCode:(NSString *)code message:(NSString *)message {
    if (promiseRejector) {
        promiseRejector(code, message, nil);
    }
    [self resetPromiseCallbacks];
}

- (void)resetPromiseCallbacks {
    promiseResolver = nil;
    promiseRejector = nil;
}

- (void)resolveApplePayCompletion:(PKPaymentAuthorizationStatus)status {
    if (applePayCompletion) {
        applePayCompletion(status);
    }
    [self resetApplePayCallback];
}

- (void)resetApplePayCallback {
    applePayCompletion = nil;
}

- (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest rejecter:(RCTPromiseRejectBlock)reject {
    if (![Stripe deviceSupportsApplePay]) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyDeviceNotSupportsNativePay];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return NO;
    }
    if (paymentRequest == nil) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyNoPaymentRequest];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return NO;
    }
    if (paymentRequest.merchantIdentifier == nil) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyNoMerchantIdentifier];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return NO;
    }
    if ([[[paymentRequest.paymentSummaryItems lastObject] amount] floatValue] == 0) {
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyNoAmount];
        reject(error[kErrorKeyCode], error[kErrorKeyDescription], nil);
        return NO;
    }
    return YES;
}


#pragma mark - STPAddCardViewControllerDelegate

- (void)addCardViewController:(STPAddCardViewController *)controller
                didCreateToken:(STPToken *)token
                    completion:(STPErrorBlock)completion {
    [RCTPresentedViewController() dismissViewControllerAnimated:YES completion:nil];

    requestIsCompleted = YES;
    completion(nil);
    [self resolvePromise:[RCTConvert STPTokenDictionary:token]];
}

- (void)addCardViewController:(STPAddCardViewController *)controller
               didCreateSource:(STPSource *)source
                   completion:(STPErrorBlock)completion {
    [RCTPresentedViewController() dismissViewControllerAnimated:YES completion:nil];

    requestIsCompleted = YES;
    completion(nil);
    [self resolvePromise:[RCTConvert STPSourceDictionary:source]];
}

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [RCTPresentedViewController() dismissViewControllerAnimated:YES completion:nil];

    if (!requestIsCompleted) {
        requestIsCompleted = YES;
        NSDictionary *error = [errorCodes valueForKey:kErrorKeyCancelled];
        [self rejectPromiseWithCode:error[kErrorKeyCode] message:error[kErrorKeyDescription]];
    }

}

#pragma mark PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                        didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    // Save for deffered call
    applePayCompletion = completion;

    STPAPIClient *stripeAPIClient = [self newAPIClient];

    [stripeAPIClient createPaymentMethodWithPayment:payment completion:^(STPPaymentMethod * _Nullable paymentMethod, NSError * _Nullable error) {
        self->requestIsCompleted = YES;

        if (error) {
            // Save for deffered use
            self->applePayStripeError = error;
            [self resolveApplePayCompletion:PKPaymentAuthorizationStatusFailure];
        } else {
            NSDictionary *result = [RCTConvert STPPaymentMethodDictionary:paymentMethod];
            NSDictionary *extra = @{
                @"billingContact": [RCTConvert PKContactDictionary:payment.billingContact] ?: [NSNull null],
                @"shippingContact": [RCTConvert PKContactDictionary:payment.shippingContact] ?: [NSNull null],
                @"shippingMethod": [RCTConvert PKShippingMethodDictionary:payment.shippingMethod] ?: [NSNull null]
            };

            [result setValue:extra forKey:@"extra"];

            [self resolvePromise:result];
        }
    }];
}


- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [self resetApplePayCallback];

    void(^completion)(void) = ^{
        if (!self->requestIsCompleted) {
            self->requestIsCompleted = YES;
            NSDictionary *error = [self->errorCodes valueForKey:kErrorKeyCancelled];
            [self rejectPromiseWithCode:error[kErrorKeyCode] message:error[kErrorKeyDescription]];
        } else {
            if (self->applePayStripeError) {
                NSDictionary *error = [self->errorCodes valueForKey:kErrorKeyApi];
                [self rejectPromiseWithCode:error[kErrorKeyCode] message:self->applePayStripeError.localizedDescription];
                self->applePayStripeError = nil;
            } else {
                [self resolvePromise:nil];
            }
        }
    };

    [RCTPresentedViewController() dismissViewControllerAnimated:YES completion:completion];
}

- (STPAPIClient *)newAPIClient {
    return [[STPAPIClient alloc] initWithPublishableKey:[Stripe defaultPublishableKey]];
}

- (PKAddressField)applePayAddressFields:(NSArray <NSString *> *)addressFieldStrings {
    PKAddressField addressField = PKAddressFieldNone;

    for (NSString *addressFieldString in addressFieldStrings) {
        addressField |= [RCTConvert PKAddressField:addressFieldString];
    }

    return addressField;
}

- (UIModalPresentationStyle)formPresentation:(NSString*)inputType {
    if ([inputType isEqualToString:@"pageSheet"])
        return UIModalPresentationPageSheet;
    if ([inputType isEqualToString:@"formSheet"])
        return UIModalPresentationFormSheet;

    return UIModalPresentationFullScreen;
}

+ (NSArray <NSString *> *)supportedPaymentNetworksStrings {
    return @[TPSPaymentNetworkAmex,
             TPSPaymentNetworkDiscover,
             TPSPaymentNetworkMasterCard,
             TPSPaymentNetworkVisa];
}

- (NSArray <PKPaymentNetwork> *)paymentNetworks:(NSArray <NSString *> *)paymentNetworkStrings {
    NSMutableArray <PKPaymentNetwork> *results = [@[] mutableCopy];

    for (NSString *paymentNetworkString in paymentNetworkStrings) {
        PKPaymentNetwork paymentNetwork = [RCTConvert PKPaymentNetwork:paymentNetworkString];
        if (paymentNetwork) {
            [results addObject:paymentNetwork];
        }
    }

    return [results copy];
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
