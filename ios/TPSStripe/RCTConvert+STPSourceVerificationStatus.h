#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPSourceVerificationStatus)

+ (NSString *)STPSourceVerificationStatusString:(STPSourceVerificationStatus)inputStatus;

@end
