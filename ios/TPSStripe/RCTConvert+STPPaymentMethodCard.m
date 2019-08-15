#import "RCTConvert+STPPaymentMethodCard.h"
#import "RCTConvert+STPCardBrand.h"

@implementation RCTConvert (STPPaymentMethodCard)

+ (NSDictionary *)STPPaymentMethodCardDictionary:(STPPaymentMethodCard*)card {
    NSMutableDictionary *dict = [@{} mutableCopy];
    [dict setValue:[RCTConvert STPCardBrandString:card.brand] forKey:@"brand"];
    if (card.funding) {
        [dict setValue:card.funding forKey:@"funding"];
    }
    [dict setValue:card.last4 forKey:@"last4"];
    [dict setValue:@(card.expMonth) forKey:@"expMonth"];
    [dict setValue:@(card.expYear) forKey:@"expYear"];
    [dict setValue:card.country forKey:@"country"];

    return dict;
}

@end

