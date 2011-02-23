//
//  CheckinsDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@interface CheckinsDataCenter : MoogleDataCenter {
  ASIHTTPRequest *_checkinsRequest;
}

@property (nonatomic, assign) ASIHTTPRequest *checkinsRequest;

@end
