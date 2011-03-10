//
//  MoogleDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenterDelegate.h"
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "JSONKit.h"
#import "NSObject+ConvenienceMethods.h"
#import "NSString+ConvenienceMethods.h"

@interface MoogleDataCenter : NSObject {
  id <MoogleDataCenterDelegate> _delegate;
  id _response;
  id _rawResponse;
  NSArray *_responseKeys;
}

@property (nonatomic, retain) id <MoogleDataCenterDelegate> delegate;
@property (nonatomic, retain) id response;
@property (nonatomic, retain) id rawResponse;
@property (nonatomic, retain) NSArray *responseKeys;


// Subclass should Implement AND call super's implementation
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request;
- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request;

@end
