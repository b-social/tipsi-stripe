#import "RCTConvert+STPToken.h"
#import "RCTConvert+STPCard.h"

@implementation RCTConvert (STPToken)

+ (NSDictionary *)STPTokenDictionary:(STPToken *)token {
    NSMutableDictionary *result = [@{} mutableCopy];
    
    // Token
    [result setValue:token.tokenId forKey:@"tokenId"];
    [result setValue:@([token.created timeIntervalSince1970]) forKey:@"created"];
    [result setValue:@(token.livemode) forKey:@"livemode"];
    
    // Card
    if (token.card) {
        [result setValue:[RCTConvert STPCardDictionary:token.card] forKey:@"card"];
    }
    
    return result;
}

@end
