//
//  Filters.h
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filters : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *categoryFilter;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, assign) BOOL offeringDeal;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, assign) NSInteger sort;

@end
