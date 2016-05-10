//
//  ISDataSyncPartnerFormatter.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/7.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISDataSyncPartnerFormatter.h"
#import "ISNetworkingSyncAPIHandler.h"
#import <GDataXML-HTML/GDataXMLNode.h>

NSString* const  kISDataSyncResut = @"kISDataSyncResut";


@implementation ISDataSyncPartnerFormatter

- (id)manager:(ISNetworkingBaseAPIHandler *)manager reformData:(id)data{
    
    if ([manager isKindOfClass:[ISNetworkingSyncAPIHandler class]]) {
        if ([data isKindOfClass:[NSData class]]) {
            NSMutableArray* retList = [NSMutableArray array];
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
            GDataXMLElement *rootElement = [doc rootElement];
            GDataXMLElement *body = [[rootElement nodesForXPath:@"//soap:Envelope/soap:Body" error:nil] firstObject];
            GDataXMLElement *response= [[body elementsForName:[NSString stringWithFormat:@"%@Response",manager.child.methodName]] firstObject];
            GDataXMLElement *resut= [[response elementsForName:[NSString stringWithFormat:@"%@Result",manager.child.methodName]] firstObject];
            GDataXMLElement *diffgr= [[resut elementsForName:@"diffgr:diffgram"] firstObject];
            GDataXMLElement *dataset = [[diffgr elementsForName:@"NewDataSet"] firstObject];
            for(GDataXMLElement * child in dataset.children){
                [retList addObject:[[ISGDataXMLHelper sharedInstance] fetchModelFromXMLElement:child withEntity:@"ISParterDataModel"]];
            }
            return @{kISDataSyncResut:retList};
        }
    }
    return nil;
}

@end
