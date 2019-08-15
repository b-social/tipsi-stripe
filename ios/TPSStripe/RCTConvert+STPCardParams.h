#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPCardParams)

+ (STPCardParams *)STPCardParams:(NSDictionary *)params;

@end
