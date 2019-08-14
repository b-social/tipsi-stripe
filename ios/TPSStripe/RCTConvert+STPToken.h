#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPToken)

+ (NSDictionary *)STPTokenDictionary:(STPToken*)token;

@end
