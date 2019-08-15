#import "RCTConvert+STPCardParams.h"

@implementation RCTConvert (STPCardParams)

+ (STPCardParams *)STPCardParams:(NSDictionary *)params {
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    
    [cardParams setNumber: params[@"number"]];
    [cardParams setExpMonth: [params[@"expMonth"] integerValue]];
    [cardParams setExpYear: [params[@"expYear"] integerValue]];
    [cardParams setCvc: params[@"cvc"]];
    
    [cardParams setCurrency: params[@"currency"]];
    [cardParams setName: params[@"name"]];
    [cardParams setAddressLine1: params[@"addressLine1"]];
    [cardParams setAddressLine2: params[@"addressLine2"]];
    [cardParams setAddressCity: params[@"addressCity"]];
    [cardParams setAddressState: params[@"addressState"]];
    [cardParams setAddressCountry: params[@"addressCountry"]];
    [cardParams setAddressZip: params[@"addressZip"]];
    
    return cardParams;
}

@end
