//
//  AppDelegate.h
//  XML Reader
//
//  Created by Frank Michael on 12/17/13.
//  Copyright (c) 2013 Frank Michael . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *urlField;
@property (assign) IBOutlet NSTextView *contentsView;
@property (assign) IBOutlet NSButton *jsonValue;
@property (nonatomic,strong) NSString *urlString;

- (IBAction)loadUrl:(id)sender;

@end
