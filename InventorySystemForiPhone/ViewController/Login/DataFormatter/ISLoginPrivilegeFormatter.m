//
//  ISLoginPrivilegeFormatter.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLoginPrivilegeFormatter.h"
#import "ISLoginFormatterKeys.h"
#import "ISNetworkingPrivilegeAPIHandler.h"
#import <GDataXML-HTML/GDataXMLNode.h>

@implementation ISLoginPrivilegeFormatter

- (id)manager:(ISNetworkingBaseAPIHandler *)manager reformData:(id)data{
    
    if ([manager isKindOfClass:[ISNetworkingPrivilegeAPIHandler class]]) {
        if ([data isKindOfClass:[NSData class]]) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
            GDataXMLElement *rootElement = [doc rootElement];
            GDataXMLElement *body = [[rootElement nodesForXPath:@"//soap:Envelope/soap:Body" error:nil] firstObject];
            GDataXMLElement *response= [[body elementsForName:[NSString stringWithFormat:@"%@Response",manager.child.methodName]] firstObject];
            GDataXMLElement *resut= [[response elementsForName:[NSString stringWithFormat:@"%@Result",manager.child.methodName]] firstObject];
            GDataXMLElement *diffgr= [[resut elementsForName:@"diffgr:diffgram"] firstObject];
            GDataXMLElement *dataset = [[diffgr elementsForName:@"NewDataSet"] firstObject];
            NSMutableArray* ret = [NSMutableArray array];
            for(GDataXMLElement* element in dataset.children){
                for(GDataXMLElement* sub in element.children){
                    if ([sub.name isEqualToString:@"prgCode"]) {
                        [ret addObject:[sub.stringValue trim]];
                    }
                }
            }
            return @{@"privilege":ret};
         }
    }
    return nil;
}

@end
