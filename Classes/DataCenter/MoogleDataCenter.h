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

@interface MoogleDataCenter : NSObject {
  id <MoogleDataCenterDelegate> _delegate;
  id _parsedResponse;
}

@property (nonatomic, retain) id <MoogleDataCenterDelegate> delegate;
@property (nonatomic, retain) id parsedResponse;

@end
