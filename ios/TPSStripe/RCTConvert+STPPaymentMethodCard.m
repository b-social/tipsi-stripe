#import "RCTConvert+STPPaymentMethodCard.h"
#import "RCTConvert+STPCardBrand.h"

@implementation RCTConvert (STPPaymentMethodCard)

+ (NSDictionary *)STPPaymentMethodCardDictionary:(STPPaymentMethodCard*)card {
    RCTLog(@"xxx card %@", card);
    NSMutableDictionary *dict = [@{} mutableCopy];
    [card setValue:[RCTConvert STPCardBrandString:card.brand] forKey:@"brand"];
    if (card.funding) {
        [card setValue:card.funding forKey:@"funding"];
    }
    [card setValue:card.last4 forKey:@"last4"];
    [card setValue:@(card.expMonth) forKey:@"expMonth"];
    [card setValue:@(card.expYear) forKey:@"expYear"];
    [card setValue:card.country forKey:@"country"];

    return dict;
}

@end

