#import <Stripe/Stripe.h>

@interface STPAPIClient (ApplePayWithPaymentMethod)

- (void)createPaymentMethodWithPayment:(PKPayment *)payment completion:(STPPaymentMethodCompletionBlock)completion;

@end
