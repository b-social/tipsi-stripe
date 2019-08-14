#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPCard)

+ (NSDictionary *)STPCardDictionary:(STPCard*)card;

@end

