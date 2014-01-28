//
//  XMLParser.h
//  XMLParser
//
//  Created by Michael  on 1/4/13.
//  Copyright (c) 2013 Michael . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSArray *allItems, NSString *rssType);
typedef void (^FailBlock)(NSString *errorMessage);

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *allItems;
    NSXMLParser *xmlParser;
    NSMutableDictionary *xmlItem;
    NSString *xmlElementName;
    NSString *rootStoryTag;
    NSString *rootXMLURL;
    id delegate;
	SuccessBlock successBlockL;
	FailBlock failBlockL;
}
- (id)initWithURL:(NSString *)xmlURL parserDidSucceed:(SuccessBlock)sblock parserDidFail:(FailBlock)fblock;
- (void)startParser;

@end