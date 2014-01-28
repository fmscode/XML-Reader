//
//  AppDelegate.m
//  XML Reader
//
//  Created by Frank Michael on 12/17/13.
//  Copyright (c) 2013 Frank Michael. All rights reserved.
//

#import "AppDelegate.h"
#import "XMLParser.h"
#import "NSJSONSerialization+JSONString.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    if (_urlString.length > 0 || _urlField.stringValue.length > 0){
        [self loadUrl:nil];
    }
}
- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    _urlString = urlString;
    _urlField.stringValue = _urlString;
    [self loadUrl:nil];
}
- (IBAction)loadUrl:(id)sender{
    _contentsView.string = @"Loading...";
    NSString *url;
    if (_urlField.stringValue.length == 0){
        url = _urlString;
    }else{
        
        url = _urlField.stringValue;
    }
    NSString *urlProto = [url substringToIndex:[url rangeOfString:@"://"].location];
    if ([urlProto isEqualToString:@"feed"]){
        url = [url stringByReplacingOccurrencesOfString:@"feed://" withString:@"http://"];
    }
    if ([_jsonValue state] == NSOffState){
        _contentsView.string = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    }else{
        XMLParser *parser = [[XMLParser alloc] initWithURL:url parserDidSucceed:^(NSArray *allItems, NSString *rssType) {
            NSString *jsonString = [NSJSONSerialization jsonStringWithObject:allItems];
            _contentsView.string = jsonString;
        } parserDidFail:^(NSString *errorMessage) {
            _contentsView.string = errorMessage;
        }];
        [parser startParser];
    }
}
@end
