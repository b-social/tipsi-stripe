#import "RCTConvert+STPSourceUsage.h"

@implementation RCTConvert (STPSourceUsage)

+ (NSString *)STPSourceUsageString:(STPSourceUsage)inputUsage {
    switch (inputUsage) {
        case STPSourceUsageReusable:
            return @"reusable";
        case STPSourceUsageSingleUse:
            return @"singleUse";
        case STPSourceUsageUnknown:
        default:
            return @"unknown";
    }
}

@end
