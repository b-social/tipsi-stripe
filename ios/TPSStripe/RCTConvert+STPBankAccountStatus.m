#import "RCTConvert+STPBankAccountStatus.h"

@implementation RCTConvert (STPBankAccountStatus)

RCT_ENUM_CONVERTER(STPBankAccountStatus,
                   (@{
                      @"new": @(STPBankAccountStatusNew),
                      @"validated": @(STPBankAccountStatusValidated),
                      @"verified": @(STPBankAccountStatusVerified),
                      @"errored": @(STPBankAccountStatusErrored),
                      }),
                   STPBankAccountStatusNew,
                   integerValue)

+ (NSString *)STPBankAccountStatusString:(STPBankAccountStatus)status {
    NSString *string = nil;
    switch (status) {
            case STPBankAccountStatusValidated: {
                string = @"validated";
            }
            break;
            case STPBankAccountStatusVerified: {
                string = @"verified";
            }
            break;
            case STPBankAccountStatusErrored: {
                string = @"errored";
            }
            break;
            case STPBankAccountStatusNew:
        default: {
            string = @"new";
        }
            break;
    }
    return string;
}

@end
