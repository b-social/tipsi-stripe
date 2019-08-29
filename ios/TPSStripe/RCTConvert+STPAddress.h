#import <React/RCTConvert.h>
#import <Stripe.h>

@interface RCTConvert (STPAddress)

+ (STPAddress *)STPAddress:(NSDictionary*)inputAddress;

@end
