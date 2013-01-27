//
//  NI_API.m
//  iNova
//
//  Created by Fedora 404 on 4/4/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "NI_API.h"
#import "AppDelegate.h"
#import "NSString+Encode.h"

@interface NI_API()
{
    NSMutableData *receivedData;
}
@end

@implementation NI_API

@synthesize lastKey = _lastKey;

// TOOL IDS
static const int TRAP_ID = 0;
static const int BARREL_ID = 1;
static const int SPIDER_ID = 2;
static const int SHIELD_ID = 3;
static const int DOOR_ID = 4;
static const int SIGN_ID = 5;

BOOL isLastKey = NO;
static NI_API* instance;

/*
    ADMINISTRATION
 */

+ (NI_API*) sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
            instance = [[NI_API alloc] init];
    }
    
    return(instance);
}

/*
    API CALLS
 */

- (NSString*)login:(NSString *)username:(NSString *)password
{
    [self generateLastKey:username];
    
    NSString* hashedPass = [self passHash:password :self.lastKey];
    NSString* params = [NSString stringWithFormat:@"login=1&pwd=%@&uname=%@&LastKey=%@", hashedPass, username, self.lastKey];
    
    return ([self send_request:@"http://data.nova-initia.com/login2.php" method:@"POST" parameters:params]);
}

- (NSString*) openPage:(NSString *)url
{
    // Get URL hashes
    NSArray* urlHashes = [self getURLHashes:url];
    NSString* urlHash = (NSString*)[urlHashes objectAtIndex:0];
    NSString* domainHash = (NSString*)[urlHashes objectAtIndex:1];
    
    // Request URL
    NSString* requestURL = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@.json?LastKey=%@", urlHash, domainHash, self.lastKey];
    
    return ([self send_request:requestURL method:@"GET" parameters:@""]);
}

- (NSString*) placeBarrelOn:(NSString *)url sg:(int)sg traps:(int)traps barrels:(int)barrels spiders:(int)spiders shields:(int)shields doorways:(int)doorways signposts:(int)signposts message:(NSString *)message label:(NSString *)label
{
    // URL-encode the parameters
    message = [message encodeString:NSUTF8StringEncoding];
    label = [label encodeString:NSUTF8StringEncoding];
    
    // Parameters
    NSString* parameters = [NSString stringWithFormat:@"Comment=%@&Label=%@&Sg=%i&Tool0=%i&Tool1=%i&Tool2=%i&Tool3=%i&Tool4=%i&Tool5=%i", message, label, sg, traps, barrels, spiders, shields, doorways, signposts];
    
    return ([self placeTool:BARREL_ID onURL:url withParameters:parameters]);
}

- (NSString*) placeDoorwayFrom:(NSString *)fromURL to:(NSString *)toURL hint:(NSString *)hint comment:(NSString *)comment nsfw:(BOOL)nsfw
{        
    // URL-encode the parameters
    NSString* fromURLEncoded = [fromURL encodeString:NSUTF8StringEncoding];
    toURL = [toURL encodeString:NSUTF8StringEncoding];
    hint = [hint encodeString:NSUTF8StringEncoding];
    comment = [comment encodeString:NSUTF8StringEncoding];
    
    // NSFW String
    NSString* nsfwString = (nsfw) ? @"true" : @"false";
    
    // Parameters
    NSString* parameters = [NSString stringWithFormat:@"Url=%@&Hint=%@&Comment=%@&Home=%@&NSFW=%@", toURL, hint, comment, fromURLEncoded, nsfwString];
    
    return ([self placeTool:DOOR_ID onURL:fromURL withParameters:parameters]);
}

- (NSString*) placeSignpostOn:(NSString *)url title:(NSString *)title comment:(NSString *)comment nsfw:(BOOL)nsfw
{
    // URL-encode the parameters
    NSString* urlEncoded = [url encodeString:NSUTF8StringEncoding];
    title = [title encodeString:NSUTF8StringEncoding];
    comment = [comment encodeString:NSUTF8StringEncoding];
    
    // NSFW String
    NSString* nsfwString = (nsfw) ? @"true" : @"false";
    
    // Parameters
    NSMutableString* parameters = [NSMutableString stringWithFormat:@"Url=%@", urlEncoded];
    if (title != @"")
        [parameters appendString:[NSString stringWithFormat:@"&Title=%@", title]];
    if (comment != @"")
        [parameters appendString:[NSString stringWithFormat:@"&Comment=%@", comment]];
    
    [parameters appendString:[NSString stringWithFormat:@"&NSFW=%@", nsfwString]];
    
    return ([self placeTool:SIGN_ID onURL:url withParameters:parameters]);
}

- (NSString*) placeSpiderOn:(NSString *)url
{
    return ([self placeTool:SPIDER_ID onURL:url withParameters:@""]);
}

- (NSString*) placeTrapOn:(NSString *)url withMessage:(NSString *)message anonymous:(BOOL)anonymous
{
    return ([self placeTool:TRAP_ID onURL:url withParameters:@""]);
}

- (NSString*) placeTool:(int)toolID onURL:(NSString *)url withParameters:(NSString *)parameters
{
    // Get URL hashes
    NSArray* urlHashes = [self getURLHashes:url];
    NSString* urlHash = (NSString*)[urlHashes objectAtIndex:0];
    NSString* domainHash = (NSString*)[urlHashes objectAtIndex:1];

    // NOTE: the parameters in the parameter string are expected to already be url-encoded

    // Request URL
    NSString* requestURL = [NSString stringWithFormat:@"http://data.nova-initia.com/rf/remog/page/%@/%@/%i.json", urlHash, domainHash, toolID];
    
    return ([self send_request:requestURL method:@"POST" parameters:parameters]);
}


/*
    ALGORITHMIC METHODS
 */

- (void)generateLastKey:(NSString *)username
{
    NSString* params = [NSString stringWithFormat:@"login=1&uname=%@" , username];
    NSString* potentialLastKey = [self send_request:@"http://data.nova-initia.com/getKey.php" method:@"POST" parameters:params];
    
    if(potentialLastKey)
        self.lastKey = potentialLastKey;
}


-(NSString*)send_request:(NSString *)theURL method:(NSString *)theMethod parameters:(NSString *)theParams
{
    NSString* response = @"";
        
    NSData *data = [theParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *length = [NSString stringWithFormat:@"%d" , [data length]];
    
    //Make the Actual Request to the Server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:theURL]];
    [request setHTTPMethod:theMethod];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.lastKey forHTTPHeaderField:@"X-NOVA-INITIA-LASTKEY"];
    [request setHTTPBody:data];
    
    //Create the connection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        receivedData = [[NSMutableData alloc] init];
        CFRunLoopRun(); // Prevents code from continuing on until it's stopped elsewhere (when we receive the data)
        response = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    }
    else
    {
        NSLog(@"Not a Valid URL");
    }
    
    return response;
}

// [0] is the hashed url as a whole, [1] is the hashed domain
- (NSArray*) getURLHashes:(NSString *)urlString
{    
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* domainString = url.host;
    
    NSString* urlHash = [self base32OfMD5:[self MD5:urlString]];
    NSString* domainHash = [self base32OfMD5:[self MD5:domainString]];
    
    NSArray* urlArray = [NSArray arrayWithObjects:urlHash, domainHash, nil];
    
    return urlArray;
}

#pragma NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    
    // This method is called when the server has determined that it
    
    // has enough information to create the NSURLResponse.
    
    
    
    // It can be called multiple times, for example in the case of a
    
    // redirect, so each time we reset the data.
    
    
    
    // receivedData is an instance variable declared elsewhere.
    
    [receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    
    [receivedData appendData:data];
    CFRunLoopStop(CFRunLoopGetCurrent()); // Stop the loop since we've gotten our response
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *value = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
}

#pragma NI Hashing Funcions

//SHA256 Hashing Function
- (NSString *)sha2:(NSString *)input 
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output; 
}

//Double Hashing for password
- (NSString *)passHash:(NSString *)password:(NSString *)lastkey
{
    NSString *hashedPass = [self sha2:password];
    hashedPass = [hashedPass stringByAppendingString:lastkey];
    hashedPass = [self sha2:hashedPass];
    return hashedPass;
}

- (void) testURLCrap
{
    NSString* testURL = @"http://www.nova-initia.com";

    NSLog(@"URL to test: %@", testURL);
    
    // Test MD5
    NSLog(@"Testing 'MD5:%@'", testURL);
    NSString* md5String = [self MD5:testURL];
    NSLog(@">> %@ -> %@", testURL, md5String);
    
    // Test base32OfMD5
    NSLog(@"Testing 'base32OfMD5:%@'", md5String);
    NSString* base32String = [self base32OfMD5:md5String];
    NSLog(@">> %@ -> %@", md5String, base32String);
}

- (NSString*) MD5:(NSString *)url
{
    // Create pointer to the string as UTF8
    const char *ptr = [url UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString*) base32OfMD5:(NSString *)md5
{
    // WARNING: DO NOT TRY TO COMPREHEND THIS LOGIC.
    // WE'VE ALREADY LOST 3 PROGRAMMERS TO SELF-INFLICTED HANGINGS
    
    NSString* base32String = @"";
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    UIWebView* webView = appDelegate.webView;
    
    for(int i = 0; i < 7; i++)
    {
        NSString* md5Substr;
        if(md5.length >= 5)
            md5Substr = [md5 substringWithRange:NSMakeRange(0, 5)];
        else 
            md5Substr = [md5 substringFromIndex:0];
        
        NSString* javascript = [NSString stringWithFormat:@"parseInt(\"%@\",16).toString(32)", md5Substr];
        
        NSString* temp = [webView stringByEvaluatingJavaScriptFromString:javascript];
        while(temp.length < (i == 6 ? 2 : 4))
        {
            temp = [NSString stringWithFormat:@"0%@", temp];
        }
        
        base32String = [NSString stringWithFormat:@"%@%@", base32String, temp];
        
        if(md5.length >= 5)
            md5 = [md5 substringFromIndex:5];
        else
            md5 = @"";
    }
    
    return base32String;
}


//Standardizing the URL
- (NSString *)standardizedURL:(NSString *)theURL{
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-z]+:\\/\\/([a-z0-9][-a-z0-9]+(\\.[a-z0-9][-a-z0-9]+)+)[^_]($|\\/|\?)?[^#]*" options:NSRegularExpressionCaseInsensitive error:&error];
    
    //Output the url
    NSString *output = [regex stringByReplacingMatchesInString:theURL options:0 range:NSMakeRange(0, theURL.length) withTemplate:@"$1"];
    
    return output;
}


@end
