#import "RCTConvert+STPCardBrand.h"

@implementation RCTConvert (STPCardBrand)

+ (NSString *)STPCardBrandString:(STPCardBrand)brand {
    switch (brand) {
            case STPCardBrandJCB:
            return @"JCB";
            case STPCardBrandAmex:
            return @"American Express";
            case STPCardBrandVisa:
            return @"Visa";
            case STPCardBrandDiscover:
            return @"Discover";
            case STPCardBrandDinersClub:
            return @"Diners Club";
            case STPCardBrandMasterCard:
            return @"MasterCard";
        default:
            return @"Unknown";
    }
}

@end
