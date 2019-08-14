#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPPaymentMethod)

+ (NSDictionary *)STPPaymentMethodDictionary:(STPPaymentMethod*)paymentMethod;

@end
