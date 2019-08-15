#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPSourceType)

+ (NSString *)STPSourceTypeString:(STPSourceType)inputType;

@end
