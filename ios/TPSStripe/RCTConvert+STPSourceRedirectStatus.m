#import "RCTConvert+STPSourceRedirectStatus.h"

@implementation RCTConvert (STPSourceRedirectStatus)

+ (NSString *)STPSourceRedirectStatusString:(STPSourceRedirectStatus)inputStatus {
    switch (inputStatus) {
        case STPSourceRedirectStatusPending:
            return @"pending";
        case STPSourceRedirectStatusSucceeded:
            return @"succeeded";
        case STPSourceRedirectStatusFailed:
            return @"failed";
        case STPSourceRedirectStatusUnknown:
        default:
            return @"unknown";
    }
}

@end
