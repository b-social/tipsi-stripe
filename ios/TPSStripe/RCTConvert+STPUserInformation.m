#import "RCTConvert+STPAddress.h"
#import "RCTConvert+STPUserInformation.h"

@implementation RCTConvert (STPUserInformation)

+ (STPUserInformation *)STPUserInformation:(NSDictionary*)inputInformation {
    STPUserInformation *userInformation = [[STPUserInformation alloc] init];
    
    [userInformation setBillingAddress: [RCTConvert STPAddress:inputInformation[@"billingAddress"]]];
    [userInformation setShippingAddress: [RCTConvert STPAddress:inputInformation[@"shippingAddress"]]];
    
    return userInformation;
}

@end
