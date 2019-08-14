#import "RCTConvert+STPCard.h"
#import "RCTConvert+STPCardBrand.h"
#import "RCTConvert+STPCardFundingType.h"

@implementation RCTConvert (STPCard)

+ (NSDictionary *)STPCardDictionary:(STPCard*)card {
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    [card setValue:card.stripeID forKey:@"cardId"];
    
    [card setValue:[RCTConvert STPCardBrandString:card.brand] forKey:@"brand"];
    [card setValue:[RCTConvert STPCardFundingTypeString:card.funding] forKey:@"funding"];
    [card setValue:card.last4 forKey:@"last4"];
    [card setValue:card.dynamicLast4 forKey:@"dynamicLast4"];
    [card setValue:@(card.isApplePayCard) forKey:@"isApplePayCard"];
    [card setValue:@(card.expMonth) forKey:@"expMonth"];
    [card setValue:@(card.expYear) forKey:@"expYear"];
    [card setValue:card.country forKey:@"country"];
    [card setValue:card.currency forKey:@"currency"];
    
    [card setValue:card.name forKey:@"name"];
    [card setValue:card.address.line1 forKey:@"addressLine1"];
    [card setValue:card.address.line2 forKey:@"addressLine2"];
    [card setValue:card.address.city forKey:@"addressCity"];
    [card setValue:card.address.state forKey:@"addressState"];
    [card setValue:card.address.country forKey:@"addressCountry"];
    [card setValue:card.address.postalCode forKey:@"addressZip"];
    
    return dict;
}

@end
