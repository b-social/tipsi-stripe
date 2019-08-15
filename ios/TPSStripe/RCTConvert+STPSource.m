#import "RCTConvert+STPSource.h"
#import "RCTConvert+STPSourceType.h"
#import "RCTConvert+STPSourceUsage.h"
#import "RCTConvert+STPSourceFlow.h"
#import "RCTConvert+STPSourceStatus.h"
#import "RCTConvert+STPSourceRedirectStatus.h"
#import "RCTConvert+STPSourceVerificationStatus.h"
#import "RCTConvert+STPSourceCardDetails.h"


@implementation RCTConvert (STPSource)

+ (NSDictionary *)STPSourceDictionary:(STPSource*)source {
    NSMutableDictionary *result = [@{} mutableCopy];
    
    // Source
    [result setValue:source.clientSecret forKey:@"clientSecret"];
    [result setValue:@([source.created timeIntervalSince1970]) forKey:@"created"];
    [result setValue:source.currency forKey:@"currency"];
    [result setValue:@(source.livemode) forKey:@"livemode"];
    [result setValue:source.amount forKey:@"amount"];
    [result setValue:source.stripeID forKey:@"sourceId"];
    
    // Flow
    [result setValue:[RCTConvert STPSourceFlowString:source.flow] forKey:@"flow"];
    
    // Metadata
    if (source.metadata) {
        [result setValue:source.metadata forKey:@"metadata"];
    }
    
    // Owner
    if (source.owner) {
        NSMutableDictionary *owner = [@{} mutableCopy];
        [result setValue:owner forKey:@"owner"];
        
        if (source.owner.address) {
            [owner setObject:source.owner.address forKey:@"address"];
        }
        [owner setValue:source.owner.email forKey:@"email"];
        [owner setValue:source.owner.name forKey:@"name"];
        [owner setValue:source.owner.phone forKey:@"phone"];
        
        if (source.owner.verifiedAddress) {
            [owner setObject:source.owner.verifiedAddress forKey:@"verifiedAddress"];
        }
        [owner setValue:source.owner.verifiedEmail forKey:@"verifiedEmail"];
        [owner setValue:source.owner.verifiedName forKey:@"verifiedName"];
        [owner setValue:source.owner.verifiedPhone forKey:@"verifiedPhone"];
    }
    
    // Details
    if (source.details) {
        [result setValue:source.details forKey:@"details"];
    }
    
    // Receiver
    if (source.receiver) {
        NSMutableDictionary *receiver = [@{} mutableCopy];
        [result setValue:receiver forKey:@"receiver"];
        
        [receiver setValue:source.receiver.address forKey:@"address"];
        [receiver setValue:source.receiver.amountCharged forKey:@"amountCharged"];
        [receiver setValue:source.receiver.amountReceived forKey:@"amountReceived"];
        [receiver setValue:source.receiver.amountReturned forKey:@"amountReturned"];
    }
    
    // Redirect
    if (source.redirect) {
        NSMutableDictionary *redirect = [@{} mutableCopy];
        [result setValue:redirect forKey:@"redirect"];
        NSString *returnURL = source.redirect.returnURL.absoluteString;
        [redirect setValue:returnURL forKey:@"returnURL"];
        NSString *url = source.redirect.url.absoluteString;
        [redirect setValue:url forKey:@"url"];
        [redirect setValue:[RCTConvert STPSourceRedirectStatusString:source.redirect.status] forKey:@"status"];
    }
    
    // Verification
    if (source.verification) {
        NSMutableDictionary *verification = [@{} mutableCopy];
        [result setValue:verification forKey:@"verification"];
        
        [verification setValue:source.verification.attemptsRemaining forKey:@"attemptsRemaining"];
        [verification setValue:[RCTConvert STPSourceVerificationStatusString:source.verification.status] forKey:@"status"];
    }
    
    // Status
    [result setValue:[RCTConvert STPSourceStatusString:source.status] forKey:@"status"];
    
    // Type
    [result setValue:[RCTConvert STPSourceTypeString:source.type] forKey:@"type"];
    
    // Usage
    [result setValue:[RCTConvert STPSourceUsageString:source.usage] forKey:@"usage"];
    
    // CardDetails
    if (source.cardDetails) {
        [result setValue:[RCTConvert STPSourceCardDetailsDictionary:source.cardDetails] forKey:@"cardDetails"];
        
    }
    
    // SepaDebitDetails
    if (source.sepaDebitDetails) {
        NSMutableDictionary *sepaDebitDetails = [@{} mutableCopy];
        [result setValue:sepaDebitDetails forKey:@"sepaDebitDetails"];
        
        [sepaDebitDetails setValue:source.sepaDebitDetails.last4 forKey:@"last4"];
        [sepaDebitDetails setValue:source.sepaDebitDetails.bankCode forKey:@"bankCode"];
        [sepaDebitDetails setValue:source.sepaDebitDetails.country forKey:@"country"];
        [sepaDebitDetails setValue:source.sepaDebitDetails.fingerprint forKey:@"fingerprint"];
        [sepaDebitDetails setValue:source.sepaDebitDetails.mandateReference forKey:@"mandateReference"];
        NSString *mandateURL = source.sepaDebitDetails.mandateURL.absoluteString;
        [sepaDebitDetails setValue:mandateURL forKey:@"mandateURL"];
    }
    
    return result;
}

@end
