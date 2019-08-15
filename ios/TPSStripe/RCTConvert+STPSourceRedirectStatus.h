#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPSourceRedirectStatus)

+ (NSString *)STPSourceRedirectStatusString:(STPSourceRedirectStatus)inputStatus;

@end
