#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPCardFundingType)

+ (NSString *)STPCardFundingTypeString:(STPCardFundingType)funding;

@end
