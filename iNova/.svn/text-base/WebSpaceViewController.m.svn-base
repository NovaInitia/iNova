//
//  ViewController.m
//  iNova
//
//  Created by Kyle Hughes on 3/31/12. 
//  Copyright (c) 2012 Code Monkey Upstairs. All rights reserved.
//

#import "WebSpaceViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "Location.h"
#import "PlaceDoorwayViewController.h"
#import "PlaceBarrelViewController.h"
#import "PlaceTrapViewController.h"
#import "PlaceSignpostViewController.h"
#import "RateDoorwayViewController.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>

@interface WebSpaceViewController ()
{
    NSURL* lastURL;
    BOOL rateHidden;
}

@end

@implementation WebSpaceViewController

@synthesize pageTitle = _pageTitle,
            addressField = _addressField,
            refreshButton = _refreshButton,
            addressBar = _addressBar,
            itemCount = _itemCount,
            rateButton = _rateButton,
            addressBarToolbar = _addressToolbar,
            webView = _webView,
            backButton = _backButton,
            forwardButton = _forwardButton,
            placeButton = _stopButton,
            menuButton = _menuButton,
            toolbar = _toolbar;

static const CGFloat MARGIN = 10.0f;
static const CGFloat SPACER = 2.0f;
static const CGFloat ADDRESS_BAR_HEIGHT = 52.0f;
static const CGFloat PAGE_TITLE_HEIGHT = 14.0f;
static  NSString* PAGE_TITLE_PLACEHOLDER_TEXT = @"iNova";
static const CGFloat ADDRESS_FIELD_HEIGHT = 26.0f;
static const CGFloat ADDRESS_FIELD_SIZE_ANIMATION_DELTA = 50.0f;
static const CGFloat ADDRESS_FIELD_REFRESH_BUTTON_HEIGHT = 14.0f;
static const CGFloat ADDRESS_FIELD_REFRESH_BUTTON_WIDTH = 12.0f;
static const CGFloat RIGHT_VIEW_MARGIN = 5;

/*
    ADMINISTRATION
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    rateHidden = YES;

    [self setupAddressBar];
    [self setupWebView];
    [self setupToolbar];
    
    // Default page
    NSString* urlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"homePage"];
    
    if (urlString == nil) 
    {
        urlString = @"http://google.com"; // For some reason 'Default Value' doesn't actually work
    }
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    // Standardize URL
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:modifiedURLString];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.pageTitle = nil;
    self.addressField = nil;
    self.refreshButton = nil;
    self.rateButton = nil;
    self.itemCount = nil;
    self.addressBar = nil;
    self.addressBarToolbar = nil;
    self.webView = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.placeButton = nil;
    self.menuButton = nil;
    self.toolbar = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

/*
    ACTION METHODS
 */

- (void) updateLocationInfo:(NSString*)urlString
{
    NSString* response = [[NI_API sharedInstance] openPage:urlString];
    
    [[Location sharedInstance] loadContentsFromJSON:response];
    
    // Let everyone know that the location has changed (MUST BE DONE LAST YOU MORON)
    [Location sharedInstance].location = urlString;
    
    // Enable menu button (if we didn't fubar, but even if we did it's OK if we're in the menu) since we're done
    self.menuButton.enabled = (![Location sharedInstance].fubar) || [MenuViewController sharedInstance].revealed;
    
    // Show true item count (if we didn't fubar)
    if(![Location sharedInstance].fubar)
    {
        int barrelCount = ([Location sharedInstance].contents.barrel) ? 1 : 0;
        int totalCount = barrelCount + [Location sharedInstance].contents.doorways.count + [Location sharedInstance].contents.signposts.count;
        self.itemCount.text = [NSString stringWithFormat:@"%i", totalCount];
    }
}

- (void) showRateDoorway
{
    NSString* nibName = [AppDelegate determineNib:@"RateDoorwayViewController"];
    UIViewController* viewController = [[RateDoorwayViewController alloc] initWithNibName:nibName bundle:nil];
    viewController.title = @"Rate Doorway";
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) toggleRate
{
    if (rateHidden)
    {
        // Animate Rate Button into view and shrink address field
        CGRect toolbarFrameVisible = self.addressBarToolbar.frame;
        toolbarFrameVisible.origin.x -= self.addressBarToolbar.frame.size.width;
        CGRect addressFieldFrameShrunken = self.addressField.frame;
        addressFieldFrameShrunken.size.width -= self.addressBarToolbar.frame.size.width - 5;
        [UIView animateWithDuration:0.3 animations:
         ^{
             [self.addressBarToolbar setFrame:toolbarFrameVisible];
             [self.addressField setFrame:addressFieldFrameShrunken];
         }];

        rateHidden = NO;
    }
    else 
    {
        CGRect toolbarFrameHidden = self.addressBarToolbar.frame;
        toolbarFrameHidden.origin.x += self.addressBarToolbar.frame.size.width;
        CGRect addressFieldFrameExpanded = self.addressField.frame;
        addressFieldFrameExpanded.size.width += self.addressBarToolbar.frame.size.width - 5;
        [UIView animateWithDuration:0.3 animations:
         ^{
             [self.addressBarToolbar setFrame:toolbarFrameHidden];
             [self.addressField setFrame:addressFieldFrameExpanded];
         }];
        
        rateHidden = YES;
    }
}

/*
    ADDRESS FIELD RELATED
 */

- (void) doneEditingAddress:(id)sender
{   /*
        ANIMATION
   
    self.addressField.rightView = self.refreshButton;
    CGRect normalFrame = self.addressField.frame;
    normalFrame.size.width += ADDRESS_FIELD_SIZE_ANIMATION_DELTA;
    [UIView animateWithDuration:0.3 animations:^{
        [self.addressField setFrame:normalFrame];
    }];
   */
}

- (void) editingAddress:(id)sender
{
    /*
        ANIMATION
     
    CGRect extendedFrame = self.addressField.frame;
    extendedFrame.size.width -= ADDRESS_FIELD_SIZE_ANIMATION_DELTA;
    [UIView animateWithDuration:0.3 animations:^{
        [self.addressField setFrame:extendedFrame];
    }];
     */
}

- (void) loadAddress:(id)sender event:(UIEvent *)event
{
    NSString* urlString = self.addressField.text;
    NSURL* url = [NSURL URLWithString:urlString];
    
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:modifiedURLString];
        self.addressField.text = modifiedURLString;
    }
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void) refreshPage:(id)sender
{
    NSURLRequest* refreshRequest = self.webView.request;
    [self.webView loadRequest:refreshRequest];
    [self updateAddress:refreshRequest];
}

/*
    WEBVIEW LOADING RELATED
 */

- (void)updateAddress:(NSURLRequest*)request
{
    NSURL* url = [request mainDocumentURL];
    NSString* absoluteAddress = [url absoluteString];
    self.addressField.text = absoluteAddress;
}

- (void) updateTitle
{
    NSString* pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
}

- (void) updateToolbarButtons
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}


/*
    UIWebViewDelegate PROTOCOL
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateAddress:request];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Disable menu button if we're not already in the menu
    self.menuButton.enabled = [MenuViewController sharedInstance].revealed;
    
    // ... for item count
    self.itemCount.text = @"...";
    
    [self updateToolbarButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // This method gets called multiple times on AJAX-involed pages; we need to prevent that
    if(webView.request.URL == lastURL)
        return;
    
    lastURL = webView.request.URL;
    
    // Update the title
    [self updateTitle];
    
    NSURLRequest* request = [webView request];
    
    // Update the address field
    [self updateAddress:request];
    
    // Update the location contents and information
    [self updateLocationInfo:self.addressField.text];
    
    // Update toolbar buttons
    [self updateToolbarButtons];
    
    // Turn off indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // If we blew up a trap by coming here
    if([Location sharedInstance].contents.trap)
    {
        Trap* trap = [Location sharedInstance].contents.trap;
        NSString* apostrophe = ([trap.username characterAtIndex:trap.username.length - 1] == 's') ? @"'" : @"'s";
        NSString* message = [NSString stringWithFormat:@"You sprung %@%@ trap. Watch where you're stepping next time.", trap.username, apostrophe];
        
        // Alert user of his missing leg
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"Boom!"
                              message: message
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    // If we got here by coming through a doorway, need ability to rate and see comment
    if([Location sharedInstance].canRateDoorway)
    {
        [Location sharedInstance].canRateDoorway = NO;
        
        // Make sure that we don't do any more size animating if it's already been done
        if(self.addressField.frame.size.width == self.addressBar.frame.size.width - 2 * MARGIN)
        {
            [self toggleRate];
        }
    }
    else 
    {
        // If we're moving away from a 'Rate Doorway' instance, we need to slide the button out of view
        if(self.addressField.frame.size.width != self.addressBar.frame.size.width - 2 * MARGIN)
        {
            [self toggleRate];
        }
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateToolbarButtons];
    //[self informError:error];
}

/*
    UIActionSheetDelegate PROTOCOL
 */

-(IBAction)showActionSheet:(id)sender
{
    UIActionSheet* placeToolSheet = [[UIActionSheet alloc] initWithTitle:@"Deploy Tools" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Leave a Barrel", @"Open a Doorway", @"Place a Signpost", @"Release a Spider", @"Set a Trap", nil];
    
    placeToolSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [placeToolSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    UIViewController* viewController;
    NSString* nibName;
    NSString* title;
    
    switch (buttonIndex) 
    {
        case 0: // BARREL
            nibName = [AppDelegate determineNib:@"PlaceBarrelViewController"];
            title = @"Leave a Barrel";
            viewController = [[PlaceBarrelViewController alloc] initWithNibName:nibName bundle:nil];
            break;
        case 1: // DOORWAY
            nibName = [AppDelegate determineNib:@"PlaceDoorwayViewController"];
            title = @"Open a Doorway";
            viewController = [[PlaceDoorwayViewController alloc] initWithNibName:nibName bundle:nil];
            break;
        case 2: // SIGNPOST
            nibName = [AppDelegate determineNib:@"PlaceSignpostViewController"];
            title = @"Place a Signpost";
            viewController = [[PlaceSignpostViewController alloc] initWithNibName:nibName bundle:nil];
            break;
        case 3: // SPIDER
            [self placeSpider];
            break;
        case 4: // TRAP
            if ([User sharedInstance].class == Giver && [User sharedInstance].level >= 5)
            {
                nibName = [AppDelegate determineNib:@"PlaceTrapViewController"];
                title = @"Set a Trap";
                viewController = [[PlaceTrapViewController alloc] initWithNibName:nibName bundle:nil];
            }
            else
            {
                [self placeTrap];
            }
            break;
        case 5: // CANCEL
            return;
        default:
            break;
    }
    
    [viewController setTitle:title];
    [self.navigationController pushViewController:viewController animated:YES];
}

/*
    ACTIONSHEET ACTION METHODS
 */

- (void) placeSpider
{
    // Get the current URL the spider is being placed on
    NSString* onURL = self.addressField.text;
    
    // Attempt to place the trap, handle the result, and display progress hud while doing it
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Releasing spider...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
       // Send request and get response
        NSString* response = [[NI_API sharedInstance] placeSpiderOn:onURL];
       
       // Handle response
       SBJsonParser* parser = [[SBJsonParser alloc] init];
       NSDictionary* data = [parser objectWithString:response];
       
       id failure = [data objectForKey:@"fail"]; // Present upon placement failure
       id pageSet = [data objectForKey:@"pageSet"]; // Present upon placement success
       id result = [data objectForKey:@"result"]; // Present upon page full-ness / trap blow-up-ness
       
       if (failure)
       {
           // Sync user inventory information
           [[User sharedInstance] syncInformationWithServer];
           
           // Alert user of result
           UIAlertView* alert = [[UIAlertView alloc]
                                 initWithTitle: @"Oops!"
                                 message: @"You tried to release a spider, but you failed and your spider was destroyed. Better luck next time!"
                                 delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
           [alert show];
       }
       else if (pageSet)
       {
           // Sync user inventory information
           [[User sharedInstance] syncInformationWithServer];
           
           // Alert user of result
           UIAlertView* alert = [[UIAlertView alloc]
                                 initWithTitle: @"Success!"
                                 message: @"Your spider was released on the page."
                                 delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
           [alert show];
       }
       else if (result)
       {
           if ([((NSString*)result) isEqualToString:@"Page Full"])
           {
               UIAlertView* alert = [[UIAlertView alloc]
                                     initWithTitle: @"Page Full"
                                     message: @"Sorry, the page has reached its item capacity. Try again later."
                                     delegate: nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
               [alert show];
           }
           else // Spider blew up a trap
           {
               // Sync user inventory information
               [[User sharedInstance] syncInformationWithServer];
               
               // Alert user of result
               UIAlertView* alert = [[UIAlertView alloc]
                                     initWithTitle: @"Boom!"
                                     message: @"Your spider blew up a trap that was set on the page, but was destroyed in the process."
                                     delegate: nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
               [alert show];
           }
       }
       else 
       {
           UIAlertView* alert = [[UIAlertView alloc]
                                 initWithTitle: @"Client Error"
                                 message: @"Something went totally haywire when attempting to release your spider. Try again later."
                                 delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
           [alert show];
       }
       
       // Hide the progress hud since we're done               
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void) placeTrap
{    
    // Get the current URL the trap is being placed on
    NSString* onURL = [[[self.webView request] URL] absoluteString];
    
    // Attempt to place the trap, handle the result, and display progress hud while doing it
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Setting trap...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
       // Send request and get response
       NSString* response = [[NI_API sharedInstance] placeTrapOn:onURL withMessage:@"" anonymous:NO];
       
       // Handle response
       SBJsonParser* parser = [[SBJsonParser alloc] init];
       NSDictionary* data = [parser objectWithString:response];
       
       id failure = [data objectForKey:@"fail"]; // Present upon placement failure
       id pageSet = [data objectForKey:@"pageSet"]; // Present upon placement success
       id result = [data objectForKey:@"result"]; // Present upon page full-ness / spider blow-up-ness
       
       if (failure)
       {
           // Sync user inventory information
           [[User sharedInstance] syncInformationWithServer];
           
           // Alert user of result
           UIAlertView* alert = [[UIAlertView alloc]
                                 initWithTitle: @"Oops!"
                                 message: @"You tried to set a trap, but you failed and your trap was destroyed. Better luck next time!"
                                 delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
           [alert show];
       }
       else if (pageSet)
       {
           // Sync user inventory information
           [[User sharedInstance] syncInformationWithServer];
           
           // Alert user of result
           UIAlertView* alert = [[UIAlertView alloc]
                                 initWithTitle: @"Success!"
                                 message: @"Your trap was set on the page.\n\nNote: if you refresh the page, you'll spring your own trap. Be careful!"
                                 delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
           [alert show];
       }
       else if (result)
       {
           if (((NSString*)result) == @"Page Full")
           {
               UIAlertView* alert = [[UIAlertView alloc]
                                     initWithTitle: @"Page Full"
                                     message: @"Sorry, the page has reached its item capacity. Try again later."
                                     delegate: nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
               [alert show];
           }
           else // Spider blew up the trap
           {
               // Sync user inventory information
               [[User sharedInstance] syncInformationWithServer];
               
               // Alert user of result
               UIAlertView* alert = [[UIAlertView alloc]
                                     initWithTitle: @"Boom!"
                                     message: @"A spider on the page blew up your trap in your face! That's gotta hurt."
                                     delegate: nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
               [alert show];
           }
       }
       else 
       {
           UIAlertView* alert = [[UIAlertView alloc]
                                 initWithTitle: @"Client Error"
                                 message: @"Something went totally haywire when attempting to set your trap. Try again later."
                                 delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
           [alert show];
       }
       
       // Hide the progress hud since we're done               
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

/*
 VIEW SETUP
 */

- (void) setupAddressBar
{
    // Address Bar
    CGRect addressBarFrame = self.view.bounds;
    addressBarFrame.size.height = ADDRESS_BAR_HEIGHT;
    UINavigationBar* addressBar = [[UINavigationBar alloc] initWithFrame:addressBarFrame];
    addressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // Page Title
    CGRect pageTitleFrame = CGRectMake(MARGIN, SPACER, addressBar.bounds.size.width - 2 * MARGIN, PAGE_TITLE_HEIGHT);
    UILabel *pageTitle = [[UILabel alloc] initWithFrame:pageTitleFrame];
    pageTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pageTitle.backgroundColor = [UIColor clearColor];
    pageTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    pageTitle.shadowColor = [[UIColor alloc] initWithWhite:1 alpha:.5];;
    pageTitle.shadowOffset = CGSizeMake(0, 1.0);
    pageTitle.textAlignment = UITextAlignmentCenter;
    pageTitle.textColor = [[UIColor alloc] initWithRed:.1992 green:.25 blue:.3125 alpha:1.0];
    [pageTitle setText:PAGE_TITLE_PLACEHOLDER_TEXT];
    [addressBar addSubview:pageTitle];
    self.pageTitle = pageTitle;
    
    
    // Address Field
    CGRect addressFieldFrame = CGRectMake(MARGIN, SPACER*2.0 + PAGE_TITLE_HEIGHT, addressBar.bounds.size.width - 2 * MARGIN, ADDRESS_FIELD_HEIGHT);
    UITextField *addressField = [[UITextField alloc] initWithFrame:addressFieldFrame];
    addressField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addressField.autocorrectionType = UITextAutocorrectionTypeNo;
    addressField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    addressField.borderStyle = UITextBorderStyleRoundedRect;
    addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addressField.contentMode = UIViewContentModeScaleAspectFill;
    addressField.font = [UIFont fontWithName:@"Helvetica" size:14];
    addressField.keyboardType = UIKeyboardTypeURL;
    addressField.placeholder = @"Go to this address";
    addressField.returnKeyType = UIReturnKeyGo;
    addressField.textColor = [UIColor darkGrayColor];
    [addressField addTarget:self 
                  action:@selector(loadAddress:event:)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    [addressField addTarget:self 
                  action:@selector(editingAddress:) 
                  forControlEvents:UIControlEventEditingDidBegin];
    [addressField addTarget:self 
                  action:@selector(doneEditingAddress:) 
                  forControlEvents:UIControlEventEditingDidEnd];
    [addressBar addSubview:addressField];
    self.addressField = addressField;
    
    // Item Count
    CGRect itemCountFrame = CGRectMake(0, 0, 50, ADDRESS_FIELD_REFRESH_BUTTON_HEIGHT + 5);
    UILabel* itemCountLabel = [[UILabel alloc] initWithFrame:itemCountFrame];
    itemCountLabel.backgroundColor = [UIColor colorWithRed:0.52156862745098 green:0.5843137254902 blue:0.65882352941176 alpha:1];
    itemCountLabel.textColor = [UIColor whiteColor];
    itemCountLabel.text = @"...";
    itemCountLabel.textAlignment = UITextAlignmentCenter;
    itemCountLabel.font = [UIFont boldSystemFontOfSize:15];
    [itemCountLabel.layer setCornerRadius:6];
    self.itemCount = itemCountLabel;
    
    // Refresh Button
    CGRect refreshFrame = CGRectMake(self.itemCount.frame.size.width + RIGHT_VIEW_MARGIN, 2, ADDRESS_FIELD_REFRESH_BUTTON_WIDTH, ADDRESS_FIELD_REFRESH_BUTTON_HEIGHT);
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:refreshFrame];
    NSString* refreshButtonImageLoc = [[NSBundle mainBundle] pathForResource:@"refreshButton" ofType:@"png"];
    UIImage* refreshButtonImage = [[UIImage alloc] initWithContentsOfFile:refreshButtonImageLoc];
    [refreshButton setImage:refreshButtonImage forState:UIControlStateNormal];
    [refreshButton addTarget:self 
                      action:@selector(refreshPage:) 
            forControlEvents:UIControlEventTouchUpInside];
    self.refreshButton = refreshButton;
    
    // Right View (for address field)
    CGRect rightViewFrame = CGRectMake(0, 0, self.refreshButton.frame.size.width + self.itemCount.frame.size.width + 10, self.itemCount.frame.size.height);
    UIView* rightView = [[UIView alloc] initWithFrame:rightViewFrame];
    [rightView addSubview:self.refreshButton];
    [rightView addSubview:self.itemCount];
    addressField.rightView = rightView;
    addressField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    // Address Bar Toolbar (this is for the buttons that slide in from the side of the address bar)
    CGRect toolbarFrame = CGRectMake(addressBar.frame.size.width, 2, 118, addressBar.frame.size.height);
    UIToolbar* addressBarToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        // Making it transparent
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [addressBarToolbar setBackgroundImage:transparentImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [addressBar addSubview:addressBarToolbar];
    self.addressBarToolbar = addressBarToolbar;
    
    // Rate Button
    UIBarButtonItem* rateButton = [[UIBarButtonItem alloc] initWithTitle:@"Rate Doorway" style:UIBarButtonItemStyleBordered target:self action:@selector(showRateDoorway)];
    [self.addressBarToolbar setItems:[NSArray arrayWithObject:rateButton] animated:YES];
    self.rateButton = rateButton;
    
    [self.view addSubview:addressBar];
    self.addressBar = addressBar;
}

- (void) setupWebView
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.webView = appDelegate.webView;
    
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    //Make sure the WebView isn't partially covered by the NavBar
    CGRect webViewFrame = self.view.bounds;
    webViewFrame.origin.y = webViewFrame.origin.y + self.addressBar.frame.size.height;
    webViewFrame.size.height = webViewFrame.size.height - self.addressBar.frame.size.height;
    [self.webView setFrame:webViewFrame];
}

- (void) setupToolbar
{
    [self.backButton setTarget:self.webView];
    [self.backButton setAction:@selector(goBack)];
    
    [self.forwardButton setTarget:self.webView];
    [self.forwardButton setAction:@selector(goForward)];
    
    [self.placeButton setTarget:self];
    [self.placeButton setAction:@selector(showActionSheet:)];
    
    [self.menuButton setTarget:[MenuViewController sharedInstance]];
    [self.menuButton setAction:@selector(toggleRevealed)];
}


@end
