#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPUserInformation)

+ (STPUserInformation *)STPUserInformation:(NSDictionary*)inputInformation;

@end
