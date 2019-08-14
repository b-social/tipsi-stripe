#import "RCTConvert+STPCardFundingType.h"

@implementation RCTConvert (STPCardFundingType)

+ (NSString *)STPCardFundingTypeString:(STPCardFundingType)funding {
    switch (funding) {
            case STPCardFundingTypeDebit:
            return @"debit";
            case STPCardFundingTypeCredit:
            return @"credit";
            case STPCardFundingTypePrepaid:
            return @"prepaid";
            case STPCardFundingTypeOther:
        default:
            return @"unknown";
    }
}

@end
