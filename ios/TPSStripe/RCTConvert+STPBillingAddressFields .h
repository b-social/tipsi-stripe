#import <React/RCTConvert.h>
#import <Stripe.h>

@interface RCTConvert (STPBillingAddressFields)

+ (STPBillingAddressFields)STPBillingAddressFields:(NSString*)inputType;

@end
