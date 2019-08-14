#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPToken)

+ (NSString *)STPCardBrandString:(STPCardBrand)brand;

@end
