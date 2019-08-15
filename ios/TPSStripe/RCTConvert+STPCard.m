#import "RCTConvert+STPCard.h"
#import "RCTConvert+STPCardBrand.h"
#import "RCTConvert+STPCardFundingType.h"

@implementation RCTConvert (STPCard)

+ (NSDictionary *)STPCardDictionary:(STPCard*)card {
    NSMutableDictionary *dict = [@{} mutableCopy];

    [dict setValue:card.stripeID forKey:@"cardId"];

    [dict setValue:[RCTConvert STPCardBrandString:card.brand] forKey:@"brand"];
    [dict setValue:[RCTConvert STPCardFundingTypeString:card.funding] forKey:@"funding"];
    [dict setValue:card.last4 forKey:@"last4"];
    [dict setValue:card.dynamicLast4 forKey:@"dynamicLast4"];
    [dict setValue:@(card.isApplePayCard) forKey:@"isApplePayCard"];
    [dict setValue:@(card.expMonth) forKey:@"expMonth"];
    [dict setValue:@(card.expYear) forKey:@"expYear"];
    [dict setValue:card.country forKey:@"country"];
    [dict setValue:card.currency forKey:@"currency"];

    [dict setValue:card.name forKey:@"name"];
    [dict setValue:card.address.line1 forKey:@"addressLine1"];
    [dict setValue:card.address.line2 forKey:@"addressLine2"];
    [dict setValue:card.address.city forKey:@"addressCity"];
    [dict setValue:card.address.state forKey:@"addressState"];
    [dict setValue:card.address.country forKey:@"addressCountry"];
    [dict setValue:card.address.postalCode forKey:@"addressZip"];

    return dict;
}

@end
