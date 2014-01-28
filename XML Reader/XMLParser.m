//
//  XMLParser.m
//  XMLParser
//
//  Created by Michael  on 1/4/13.
//  Copyright (c) 2013 Michael . All rights reserved.
//

#import "XMLParser.h"

@interface XMLParser ()

@end

@implementation XMLParser

- (id)initWithURL:(NSString *)xmlURL parserDidSucceed:(SuccessBlock)sblock parserDidFail:(FailBlock)fblock{
    if (self){
        
    }
    rootXMLURL = xmlURL;
	successBlockL = sblock;
	failBlockL = fblock;

    return self;
}

- (void)startParser{
    [NSThread detachNewThreadSelector:@selector(parseXMLFileAtURL) toTarget:self withObject:nil];
}

#pragma mark - XML Parser
- (void)parseXMLFileAtURL{
    @autoreleasepool {
		allItems = [[NSMutableArray alloc] init];
		        
		xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:rootXMLURL]];
		[xmlParser setDelegate:self];
        // NSXML Settings
        [xmlParser setShouldProcessNamespaces:NO];
		[xmlParser setShouldReportNamespacePrefixes:NO];
		[xmlParser setShouldResolveExternalEntities:NO];
        // Start the NSXML Parser
		[xmlParser parse];
    }
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	@autoreleasepool {
		dispatch_async(dispatch_get_main_queue(), ^{	//Move from the rss thread to the main thread.
			failBlockL([parseError localizedDescription]);
		});
	}
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    @autoreleasepool {
//        NSLog(@"Found Element: %@", elementName);
        if ([elementName isEqualToString:@"entry"] || [elementName isEqualToString:@"item"]){
            rootStoryTag = elementName;
            xmlItem = [[NSMutableDictionary alloc] init];
        }
        xmlElementName = elementName;
    }
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    @autoreleasepool {
//        NSLog(@"Found Text: %@", string);
        if (![xmlElementName isEqualToString:rootStoryTag]){
            NSMutableString *currentElementText = [[NSMutableString alloc] init];
            if ([xmlItem objectForKey:xmlElementName] != nil){  // Check if current element has any exisiting text in it.
                [currentElementText appendString:[xmlItem objectForKey:xmlElementName]];
            }
            [currentElementText appendString:string];
            [currentElementText replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [currentElementText length])];
            [currentElementText replaceOccurrencesOfString:@"\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [currentElementText length])];
            if (currentElementText.length > 0){     // Make sure text was actually added to the element text.
                [xmlItem setObject:currentElementText forKey:xmlElementName];
            }
        }
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    @autoreleasepool {
        if ([rootStoryTag isEqualToString:elementName]){
            // Element is a root element so save the object to a array.
            [allItems addObject:xmlItem];
        }
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    @autoreleasepool {
		dispatch_async(dispatch_get_main_queue(), ^{	// Move from the rss thread to the main thread
            NSLog(@"%@",rootStoryTag);
//            NSLog(@"%@",[allItems objectAtIndex:0]);
			successBlockL(allItems,rootStoryTag);
        });
    }    
}

@end
