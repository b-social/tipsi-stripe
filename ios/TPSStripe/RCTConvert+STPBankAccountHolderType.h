#import <React/RCTConvert.h>
#import <Stripe/Stripe.h>

@interface RCTConvert (STPBankAccountHolderType)

+ (STPBankAccountHolderType)STPBankAccountHolderType:(id)json;
+ (NSString *)STPBankAccountHolderTypeString:(STPBankAccountHolderType)type;

@end
