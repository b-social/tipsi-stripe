#import "RCTConvert+STPPaymentMethod.h"
#import "RCTConvert+STPPaymentMethodCard.h"

@implementation RCTConvert (STPPaymentMethod)

+ (NSDictionary *)STPPaymentMethodDictionary:(STPPaymentMethod*)paymentMethod {
    RCTLog(@"xxx stp paymentMethod %@", paymentMethod);
    NSMutableDictionary *result = [@{} mutableCopy];
    
    // Token
    [result setValue:paymentMethod.stripeId forKey:@"tokenId"];
    [result setValue:@([paymentMethod.created timeIntervalSince1970]) forKey:@"created"];
    
    [result setValue:@(paymentMethod.liveMode) forKey:@"livemode"];
    
    // Card
    if (paymentMethod.card) {
        [result setValue:[RCTConvert STPPaymentMethodCardDictionary:paymentMethod.card] forKey:@"card"];
    }
    
    return result;
}

@end

