//
//  ISOrderInfoFormatter.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/16.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISOrderInfoFormatter.h"
#import <GDataXML-HTML/GDataXMLNode.h>
#import "ISNetworkingPriceAPIHandler.h"
#import "ISNetworkingStockAPIHandler.h"
#import "ISNetworkingLastInfoAPIHandler.h"
#import "ISNetworkingUploadOrderAPIHandler.h"
#import "ISNetworkingUploadReturnOrderAPIHandler.h"
#import "ISNetworkingUploadOrderPicAPIHandler.h"


NSString* const  kISOderInfoResut = @"kISOderInfoResut";


@implementation ISOrderInfoFormatter

- (id)manager:(ISNetworkingBaseAPIHandler *)manager reformData:(id)data{
    
    if ([manager isKindOfClass:[ISNetworkingPriceAPIHandler class]] || [manager isKindOfClass:[ISNetworkingStockAPIHandler class]] || [manager isKindOfClass:[ISNetworkingLastInfoAPIHandler class]] || [manager isKindOfClass:[ISNetworkingUploadOrderAPIHandler class]] || [manager isKindOfClass:[ISNetworkingUploadOrderPicAPIHandler class]] || [manager isKindOfClass:[ISNetworkingUploadReturnOrderAPIHandler class]]) {
        if ([data isKindOfClass:[NSData class]]) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
            GDataXMLElement *rootElement = [doc rootElement];
            GDataXMLElement *body = [[rootElement nodesForXPath:@"//soap:Envelope/soap:Body" error:nil] firstObject];
            GDataXMLElement *response= [[body elementsForName:[NSString stringWithFormat:@"%@Response",manager.child.methodName]] firstObject];
            GDataXMLElement *resut= [[response elementsForName:[NSString stringWithFormat:@"%@Result",manager.child.methodName]] firstObject];
            return @{kISOderInfoResut:resut.stringValue};
        }
    }
    return nil;
}

@end
