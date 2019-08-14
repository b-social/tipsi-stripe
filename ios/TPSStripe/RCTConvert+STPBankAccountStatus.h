#import <React/RCTConvert.h>
#import <Stripe.h>

@interface RCTConvert (STPBankAccountStatus)

+ (STPBankAccountStatus)STPBankAccountStatus:(id)json;
+ (NSString *)STPBankAccountStatusString:(STPBankAccountStatus)status;

@end
