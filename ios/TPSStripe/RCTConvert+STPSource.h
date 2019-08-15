#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPSource)

+ (NSDictionary *)STPSourceDictionary:(STPSource*)source;

@end
