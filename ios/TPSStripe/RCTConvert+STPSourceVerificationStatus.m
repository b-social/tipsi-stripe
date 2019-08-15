#import "RCTConvert+STPSourceVerificationStatus.h"

@implementation RCTConvert (STPSourceVerificationStatus)

+ (NSString *)STPSourceVerificationStatusString:(STPSourceVerificationStatus)inputStatus {
    switch (inputStatus) {
        case STPSourceVerificationStatusPending:
            return @"pending";
        case STPSourceVerificationStatusSucceeded:
            return @"succeeded";
        case STPSourceVerificationStatusFailed:
            return @"failed";
        case STPSourceVerificationStatusUnknown:
        default:
            return @"unknown";
    }
}

@end
