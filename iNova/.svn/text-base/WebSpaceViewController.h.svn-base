//
//  ViewController.h
//  iNova
//
//  Created by Kyle Hughes on 3/31/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebSpaceViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) UILabel* pageTitle;
@property (nonatomic, retain) UITextField* addressField;
@property (nonatomic, retain) UIButton* refreshButton;
@property (nonatomic, retain) UILabel*  itemCount;
@property (nonatomic, retain) UINavigationBar* addressBar;

@property (nonatomic, retain) UIBarButtonItem* rateButton;
@property (nonatomic, retain) UIToolbar* addressBarToolbar;

@property (nonatomic, retain) UIWebView* webView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* placeButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* menuButton;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;

- (void) showRateDoorway;

- (void) doneEditingAddress:(id)sender;
- (void) editingAddress:(id)sender;
- (void) loadAddress:(id)sender  event:(UIEvent*)event;
- (void) refreshPage:(id)sender;

- (void) updateLocationInfo:(NSString*)urlString;

- (void) placeSpider;
- (void) placeTrap;

- (void) toggleRate;

- (void) updateAddress:(NSURLRequest*)request;
- (void) updateTitle;
- (void) updateToolbarButtons;

- (void) setupAddressBar;
- (void) setupToolbar;
- (void) setupWebView;

@end
