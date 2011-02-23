/*
 *  MoogleDataCenterDelegate.h
 *  Moogle
 *
 *  Created by Peter Shih on 2/22/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "ASIHTTPRequest.h"

@protocol MoogleDataCenterDelegate <NSObject>

@optional
- (void)dataCenterDidStart:(ASIHTTPRequest *)request;
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request;

@end
