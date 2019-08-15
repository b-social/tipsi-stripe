#import "RCTConvert+STPSourceCardDetails.h"
#import "RCTConvert+STPCardBrand.h"
#import "RCTConvert+STPCardFundingType.h"
#import "RCTConvert+STPSourceCard3DSecureStatus.h"

@implementation RCTConvert (STPSourceCardDetails)

+ (NSDictionary*)STPSourceCardDetailsDictionary:(STPSourceCardDetails*)cardDetails {
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    
    [cardDetails setValue:cardDetails.last4 forKey:@"last4"];
    [cardDetails setValue:@(cardDetails.expMonth) forKey:@"expMonth"];
    [cardDetails setValue:@(cardDetails.expYear) forKey:@"expYear"];
    [cardDetails setValue:[RCTConvert STPCardBrandString:cardDetails.brand] forKey:@"brand"];
    [cardDetails setValue:[RCTConvert STPCardFundingTypeString:cardDetails.funding] forKey:@"funding"];
    [cardDetails setValue:cardDetails.country forKey:@"country"];
    [cardDetails setValue:[RCTConvert STPSourceCard3DSecureStatusString:cardDetails.threeDSecure] forKey:@"threeDSecure"];
    
    return dict;
}

@end
