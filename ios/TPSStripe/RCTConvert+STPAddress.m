#import "RCTConvert+STPAddress.h"

@implementation RCTConvert (STPAddress)

+ (STPAddress *)STPAddress:(NSDictionary*)inputAddress {
    STPAddress *address = [[STPAddress alloc] init];
    
    [address setName:inputAddress[@"name"]];
    [address setLine1:inputAddress[@"line1"]];
    [address setLine2:inputAddress[@"line2"]];
    [address setCity:inputAddress[@"city"]];
    [address setState:inputAddress[@"state"]];
    [address setPostalCode:inputAddress[@"postalCode"]];
    [address setCountry:inputAddress[@"country"]];
    [address setPhone:inputAddress[@"phone"]];
    [address setEmail:inputAddress[@"email"]];
    
    return address;
}
@end
