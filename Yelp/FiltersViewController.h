//
//  FiltersViewController.h
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Filters.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(Filters *)filters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, copy) Filters *filters;
@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

- (id)initWithFilters:(Filters *)filters;

@end
