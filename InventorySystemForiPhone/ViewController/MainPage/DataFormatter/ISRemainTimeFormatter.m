//
//  ISRemainTimeFormatter.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/5.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISRemainTimeFormatter.h"
#import "ISNetworkingRemainTimeAPIHandler.h"
#import "ISNetworkingRegisterInfoAPIHandler.h"
#import <GDataXML-HTML/GDataXMLNode.h>

NSString* const  kISRemainTimeResut = @"kISRemainTimeResut";

NSString* const  kISRemainTimeDeviceId = @"HashID";
NSString* const  kISRemainTimeUser = @"UserName";
NSString* const  kISRemainTimeExpirationDay = @"liveDay";
NSString* const  kISRemainTimeLastLoginDate = @"LastChkDate";


@implementation ISRemainTimeFormatter

- (id)manager:(ISNetworkingBaseAPIHandler *)manager reformData:(id)data{
    
    if ([manager isKindOfClass:[ISNetworkingRemainTimeAPIHandler class]]) {
        if ([data isKindOfClass:[NSData class]]) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
            GDataXMLElement *rootElement = [doc rootElement];
            GDataXMLElement *body = [[rootElement nodesForXPath:@"//soap:Envelope/soap:Body" error:nil] firstObject];
            GDataXMLElement *response= [[body elementsForName:[NSString stringWithFormat:@"%@Response",manager.child.methodName]] firstObject];
            GDataXMLElement *resut= [[response elementsForName:[NSString stringWithFormat:@"%@Result",manager.child.methodName]] firstObject];
            return @{kISRemainTimeResut:resut.stringValue};
        }
    }
    
    if ([manager isKindOfClass:[ISNetworkingRegisterInfoAPIHandler class]]) {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
        GDataXMLElement *rootElement = [doc rootElement];
        GDataXMLElement *body = [[rootElement nodesForXPath:@"//soap:Envelope/soap:Body" error:nil] firstObject];
        GDataXMLElement *response= [[body elementsForName:[NSString stringWithFormat:@"%@Response",manager.child.methodName]] firstObject];
        GDataXMLElement *resut= [[response elementsForName:[NSString stringWithFormat:@"%@Result",manager.child.methodName]] firstObject];
        GDataXMLElement *diffgr= [[resut elementsForName:@"diffgr:diffgram"] firstObject];
        GDataXMLElement *dataset = [[diffgr elementsForName:@"NewDataSet"] firstObject];
        GDataXMLElement *version = [[dataset elementsForName:@"version"] firstObject];
        
        
        return @{kISRemainTimeDeviceId:[[ISGDataXMLHelper sharedInstance] safeStringFromData:[[[version elementsForName:kISRemainTimeDeviceId] firstObject] stringValue]],
                 kISRemainTimeUser:[[ISGDataXMLHelper sharedInstance] safeStringFromData:[[[version elementsForName:kISRemainTimeUser] firstObject] stringValue]],
                 kISRemainTimeExpirationDay:[[ISGDataXMLHelper sharedInstance] safeStringFromData:[[[version elementsForName:kISRemainTimeExpirationDay] firstObject] stringValue]],
                 kISRemainTimeLastLoginDate:[[ISGDataXMLHelper sharedInstance] safeStringFromData:[[[version elementsForName:kISRemainTimeLastLoginDate] firstObject] stringValue]]};
    }
    return nil;
}

@end
