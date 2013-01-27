//
//  NI_API.h
//  iNova
//
//  Created by Fedora 404 on 4/4/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCrypto/CommonDigest.h"

@interface NI_API : NSObject

@property (nonatomic , retain) NSString *lastKey;

- (void) testURLCrap;

//Singleton
+ (NI_API*) sharedInstance;

//Helper methods
- (NSString *)sha2:(NSString *)data;
- (NSString *)passHash:(NSString *)data:(NSString *)lastkey;
- (void)generateLastKey:(NSString *)username;
- (NSArray*) getURLHashes:(NSString*)urlString;
- (NSString*) MD5:(NSString*)url;
- (NSString*) base32OfMD5:(NSString*)md5;
- (NSString*) placeTool:(int)toolID onURL:(NSString*)url withParameters:(NSString*)parameters; 

//Calls
- (NSString*) login:(NSString *)username:(NSString *)password;
- (NSString*) openPage:(NSString*)url;
- (NSString*) placeBarrelOn:(NSString*)url sg:(int)sg traps:(int)traps barrels:(int)barrels spiders:(int)spiders shields:(int)shields doorways:(int)doorways signposts:(int)signposts message:(NSString*)message label:(NSString*)label;
- (NSString*) placeDoorwayFrom:(NSString*)fromURL to:(NSString*)toURL hint:(NSString*)hint comment:(NSString*)comment nsfw:(BOOL)nsfw;
- (NSString*) placeSignpostOn:(NSString*)url title:(NSString*)title comment:(NSString*)comment nsfw:(BOOL)nsfw;
- (NSString*) placeSpiderOn:(NSString*)url;
- (NSString*) placeTrapOn:(NSString*)url withMessage:(NSString*)message anonymous:(BOOL)anonymous;


//Request Methods
- (NSString*)send_request:(NSString *)theURL method:(NSString *)theMethod parameters:(NSString *)theParams;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
