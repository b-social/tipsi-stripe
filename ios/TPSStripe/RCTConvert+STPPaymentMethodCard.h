#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPPaymentMethodCard)

+ (NSDictionary *)STPPaymentMethodCardDictionary:(STPPaymentMethodCard*)card;

@end
