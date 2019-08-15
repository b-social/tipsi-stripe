#import "RCTConvert+STPSourceParams.h"
#import "RCTConvert+STPCardParams.h"

@implementation RCTConvert (STPSourceParams)

+ (STPSourceParams*)STPSourceParams:(id)params {
    NSString *sourceType = params[@"type"];
    STPSourceParams *sourceParams;
    if ([sourceType isEqualToString:@"bancontact"]) {
        sourceParams = [STPSourceParams bancontactParamsWithAmount:[[params objectForKey:@"amount"] unsignedIntegerValue] name:params[@"name"] returnURL:params[@"returnURL"] statementDescriptor:params[@"statementDescriptor"]];
    }
    if ([sourceType isEqualToString:@"giropay"]) {
        sourceParams = [STPSourceParams giropayParamsWithAmount:[[params objectForKey:@"amount"] unsignedIntegerValue] name:params[@"name"] returnURL:params[@"returnURL"] statementDescriptor:params[@"statementDescriptor"]];
    }
    if ([sourceType isEqualToString:@"ideal"]) {
        sourceParams = [STPSourceParams idealParamsWithAmount:[[params objectForKey:@"amount"] unsignedIntegerValue] name:params[@"name"] returnURL:params[@"returnURL"] statementDescriptor:params[@"statementDescriptor"] bank:params[@"bank"]];
    }
    if ([sourceType isEqualToString:@"sepaDebit"]) {
        sourceParams = [STPSourceParams sepaDebitParamsWithName:params[@"name"] iban:params[@"iban"] addressLine1:params[@"addressLine1"] city:params[@"city"] postalCode:params[@"postalCode"] country:params[@"country"]];
    }
    if ([sourceType isEqualToString:@"sofort"]) {
        sourceParams = [STPSourceParams sofortParamsWithAmount:[[params objectForKey:@"amount"] unsignedIntegerValue] returnURL:params[@"returnURL"] country:params[@"country"] statementDescriptor:params[@"statementDescriptor"]];
    }
    if ([sourceType isEqualToString:@"threeDSecure"]) {
        sourceParams = [STPSourceParams threeDSecureParamsWithAmount:[[params objectForKey:@"amount"] unsignedIntegerValue] currency:params[@"currency"] returnURL:params[@"returnURL"] card:params[@"card"]];
    }
    if ([sourceType isEqualToString:@"alipay"]) {
        sourceParams = [STPSourceParams alipayParamsWithAmount:[[params objectForKey:@"amount"] unsignedIntegerValue] currency:params[@"currency"] returnURL:params[@"returnURL"]];
    }
    if ([sourceType isEqualToString:@"card"]) {
        sourceParams = [STPSourceParams cardParamsWithCard:[RCTConvert STPCardParams:params]];
    }
    
    return sourceParams;
}

@end
