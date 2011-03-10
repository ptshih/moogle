//
//  MePlacesViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPlacesTableViewController.h"

@interface MePlacesViewController : CardPlacesTableViewController {
  NSArray *_rawPlacesArray;
  NSMutableArray *_topPlacesArray;
}

@property (nonatomic, retain) NSArray *rawPlacesArray;
@property (nonatomic, retain) NSMutableArray *topPlacesArray;

- (void)getTopPlaces;

@end
