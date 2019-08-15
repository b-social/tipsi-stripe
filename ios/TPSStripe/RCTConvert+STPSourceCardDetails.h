#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPSourceCardDetails)

+ (NSDictionary*)STPSourceCardDetailsDictionary:(STPSourceCardDetails*)cardDetails;

@end
