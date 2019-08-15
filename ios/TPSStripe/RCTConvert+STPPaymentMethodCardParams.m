#import "RCTConvert+STPPaymentMethodCardParams.h"

@implementation RCTConvert (STPPaymentMethodCardParams)

+ (STPPaymentMethodCardParams*)STPPaymentMethodCardParams:(id)params {
    STPPaymentMethodCardParams *cardParams = [STPPaymentMethodCardParams new];
    
    [cardParams setNumber: params[@"number"]];
    [cardParams setExpMonth: params[@"expMonth"]];
    [cardParams setExpYear: params[@"expYear"]];
    [cardParams setCvc: params[@"cvc"]];
    
    return cardParams;
}

@end
