//
//  ISLoginResutFormatter.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginResutFormatter.h"
#import "ISNetworkingLoginAPIHandler.h"
#import <GDataXML-HTML/GDataXMLNode.h>


NSString* const  kISLoginResut = @"kISLoginResut";

@implementation ISLoginResutFormatter

- (id)manager:(ISNetworkingBaseAPIHandler *)manager reformData:(id)data{
    
    if ([manager isKindOfClass:[ISNetworkingLoginAPIHandler class]]) {
        if ([data isKindOfClass:[NSData class]]) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
            GDataXMLElement *rootElement = [doc rootElement];
            GDataXMLElement *body = [[rootElement nodesForXPath:@"//soap:Envelope/soap:Body" error:nil] firstObject];
            GDataXMLElement *response= [[body elementsForName:[NSString stringWithFormat:@"%@Response",manager.child.methodName]] firstObject];
            GDataXMLElement *resut= [[response elementsForName:[NSString stringWithFormat:@"%@Result",manager.child.methodName]] firstObject];
            return @{kISLoginResut:resut.stringValue};
        }
    }
    return nil;
}


@end
