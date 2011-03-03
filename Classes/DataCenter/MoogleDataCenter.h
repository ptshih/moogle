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
#import "CJSONDeserializer.h"
#import "NSObject+ConvenienceMethods.h"
#import "NSString+ConvenienceMethods.h"

@interface MoogleDataCenter : NSObject {
  id <MoogleDataCenterDelegate> _delegate;
  id _response;
  NSArray *_responseKeys;
}

@property (nonatomic, retain) id <MoogleDataCenterDelegate> delegate;
@property (nonatomic, retain) id response;
@property (nonatomic, retain) NSArray *responseKeys;


// Subclass should Implement AND call super's implementation
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request;
- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request;

@end
