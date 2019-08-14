#import "STPAPIClient+ApplePayWithPaymentMethod.h"

/**
 * This is only needed until Stripe fix their library
 */

@implementation STPAPIClient (ApplePayWithPaymentMethod)

/**
 * This is only needed until Stripe fix their library
 */
- (void)createPaymentMethodWithPayment:(PKPayment *)payment completion:(STPPaymentMethodCompletionBlock)completion {
    NSCAssert(payment != nil, @"'payment' is required to create an apple pay payment method");
    NSCAssert(completion != nil, @"'completion' is required to use the payment method that is created");
    
    [self createTokenWithPayment:payment completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
        if (token.tokenId == nil
            || error != nil) {
            //            completion(nil, error ?: [NSError stp_genericConnectionError]);
            completion(nil, error ?: [NSError errorWithDomain:@"com.b-social" code:-1 userInfo:nil]);
        }
        else {
            STPPaymentMethodCardParams *cardParams = [STPPaymentMethodCardParams new];
            cardParams.token = token.tokenId;
            STPPaymentMethodParams *paymentMethodParams =
            [STPPaymentMethodParams paramsWithCard:cardParams
                                    billingDetails:nil
                                          metadata:nil];
            [self createPaymentMethodWithParams:paymentMethodParams
                                     completion:completion];
        }
    }];
}

@end
