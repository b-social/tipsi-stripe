#import "RCTConvert+STPSourceCard3DSecureStatus.h"

@implementation RCTConvert (STPSourceCard3DSecureStatus)

+ (NSString *)STPSourceCard3DSecureStatusString:(STPSourceCard3DSecureStatus)inputStatus {
    switch (inputStatus) {
        case STPSourceCard3DSecureStatusRequired:
            return @"required";
        case STPSourceCard3DSecureStatusOptional:
            return @"optional";
        case STPSourceCard3DSecureStatusNotSupported:
            return @"notSupported";
        case STPSourceCard3DSecureStatusUnknown:
        default:
            return @"unknown";
    }
}

@end
