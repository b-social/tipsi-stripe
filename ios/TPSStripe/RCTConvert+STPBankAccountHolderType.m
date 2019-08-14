//
//  RCTConvert+STPBankAccountHolderType.m
//  bsocial
//
//  Created by Ayman Osman on 13/08/2019.
//  Copyright © 2019 B Social. All rights reserved.
//

#import "RCTConvert+STPBankAccountHolderType.h"

@implementation RCTConvert (STPBankAccountHolderType)

RCT_ENUM_CONVERTER(STPBankAccountHolderType,
                   (@{
                      @"individual": @(STPBankAccountHolderTypeIndividual),
                      @"company": @(STPBankAccountHolderTypeCompany),
                      }),
                   STPBankAccountHolderTypeCompany,
                   integerValue)

+ (NSString *)STPBankAccountHolderTypeString:(STPBankAccountHolderType)type {
    NSString *string = nil;
    switch (type) {
            case STPBankAccountHolderTypeCompany: {
                string = @"company";
            }
            break;
            case STPBankAccountHolderTypeIndividual:
        default: {
            string = @"individual";
        }
            break;
    }
    return string;
}

@end
