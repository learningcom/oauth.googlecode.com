//
//  OAMutableURLRequest.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Back-ported to obj-c 1.x by George Fletcher


#import "OAMutableURLRequest.h"


@interface OAMutableURLRequest (Private)
- (void)_generateTimestamp;
- (void)_generateNonce;
- (NSString *)_signatureBaseString;

- (NSString *)timestamp;
- (void)setTimestamp:(NSString *)aString;
@end

@implementation OAMutableURLRequest
// No @synthesize in Obj-c 1.x -- GFF
//@synthesize signature, nonce;

#pragma mark init

- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
signatureProvider:(NSObject <OASignatureProviding>*)aProvider {
    
    [super initWithURL:aUrl
           cachePolicy:NSURLRequestReloadIgnoringCacheData
       timeoutInterval:10.0];
    
    [self setSignature:nil];
    
    consumer = [aConsumer retain];
    
    // empty token for Unauthorized Request Token transaction
    if (aToken == nil) {
        token = [[OAToken alloc] init];
    } else {
        token = [aToken retain];
    }
    
    if (aRealm == nil) {
        realm = [@"" retain];
    } else {
        realm = [aRealm copy];
    }
      
    // default to HMAC-SHA1
    if (aProvider == nil) {
        signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    } else {
        signatureProvider = [aProvider retain];
    }
    
    [self _generateTimestamp];
    [self _generateNonce];
    
    return self;
}

// Setting a timestamp and nonce to known
// values can be helpful for testing
- (id)initWithURL:(NSURL *)aUrl
		 consumer:(OAConsumer *)aConsumer
			token:(OAToken *)aToken
            realm:(NSString *)aRealm
signatureProvider:(NSObject <OASignatureProviding>*) aProvider
            nonce:(NSString *)aNonce
        timestamp:(NSString *)aTimestamp {
    
    [self initWithURL:aUrl
             consumer:aConsumer
                token:aToken
                realm:aRealm
    signatureProvider:aProvider];
    
    [self setNonce:[[aNonce copy] autorelease]];
    [self setTimestamp:[[aTimestamp copy] autorelease]];
    
    return self;
}


- (void) dealloc;
{
    [consumer release];
    consumer = nil;
    [token release];
    token = nil;
    [realm release];
    realm = nil;
    [signatureProvider release];
    signatureProvider = nil;
    
    [self setTimestamp:nil];
    [self setNonce:nil];
    [self setSignature:nil];
    
    [super dealloc];
}


- (void)prepare {
    // sign
    signature = [signatureProvider signClearText:[self _signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
                                                  [[consumer secret] encodedURLParameterString],
                                                  [[token secret] encodedURLParameterString]]];
    [signature retain];
    
    // set OAuth headers
    
    NSString *oauthToken;
    if ([[token key] isEqualToString:@""]) {
        oauthToken = @""; // not used on Request Token transactions
    } else {
        oauthToken = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [[token key] encodedURLParameterString]];
    }
    
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=\"%@\", oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"",
                             [realm encodedURLParameterString],
                             [[consumer key] encodedURLParameterString],
                             oauthToken,
                             [[signatureProvider name] encodedURLParameterString],
                             [signature encodedURLParameterString],
                             timestamp,
                             nonce];
    NSLog(@"oauthHeader: %@", oauthHeader);

    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}

- (void)_generateTimestamp {
    [self setTimestamp:[NSString stringWithFormat:@"%d", time(NULL)]];
}

- (void)_generateNonce {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    //NSMakeCollectable(theUUID);
    [self setNonce:(NSString *)string];
    CFRelease(string);
}

- (NSString *)_signatureBaseString {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
    NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:(6 + [[self parameters] count])]; // 6 being the number of OAuth params in the Signature Base String
    [parameterPairs addObject:[[[[OARequestParameter alloc] initWithName:@"oauth_consumer_key" value:[consumer key]] autorelease] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[[[OARequestParameter alloc] initWithName:@"oauth_signature_method" value:[signatureProvider name]] autorelease] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[[[OARequestParameter alloc] initWithName:@"oauth_timestamp" value:timestamp] autorelease]URLEncodedNameValuePair]];
    [parameterPairs addObject:[[[[OARequestParameter alloc] initWithName:@"oauth_nonce" value:nonce] autorelease] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[[[OARequestParameter alloc] initWithName:@"oauth_version" value:@"1.0"] autorelease] URLEncodedNameValuePair]];
    
    if (![[token key] isEqualToString:@""]) {
        [parameterPairs addObject:[[[[OARequestParameter alloc] initWithName:@"oauth_token" value:[token key]] autorelease] URLEncodedNameValuePair]];
    }
    
    // Convert for loop to be obj-c 1.x compliant
    int count, i;
    count = [[self parameters] count];
    for ( i = 0; i < count; i++ ) {
        OARequestParameter *param = [[self parameters] objectAtIndex:i];
        [parameterPairs addObject:[param URLEncodedNameValuePair]];
    }
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    [parameterPairs release];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    return [NSString stringWithFormat:@"%@&%@&%@",
            [self HTTPMethod],
            [[[self URL] URLStringWithoutQuery] encodedURLParameterString],
            [normalizedRequestParameters encodedURLString]];
}

#pragma mark properties

- (NSString *)nonce
{
    return nonce;
}
- (void)setNonce:(NSString *)aNonce
{
    [aNonce retain];
    [nonce release];
    nonce = aNonce;
}

- (NSString *)signature
{
    return signature;
}
- (void)setSignature:(NSString *)aSignature
{
    [aSignature retain];
    [signature release];
    signature = aSignature;
}


- (NSString *)timestamp;
{
    return timestamp;
}
- (void)setTimestamp:(NSString *)aString;
{
    [aString retain];
    [timestamp release];
    timestamp = aString;
}

@end
