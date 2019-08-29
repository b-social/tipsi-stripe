#import "RCTConvert+STPBillingAddressFields .h"

@implementation RCTConvert (STPBillingAddressFields)

+ (STPBillingAddressFields)STPBillingAddressFields:(NSString*)inputType {
    if ([inputType isEqualToString:@"zip"]) {
        return STPBillingAddressFieldsZip;
    }
    if ([inputType isEqualToString:@"full"]) {
        return STPBillingAddressFieldsFull;
    }
    return STPBillingAddressFieldsNone;
}

@end
