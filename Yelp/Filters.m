//
//  Filters.m
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Filters.h"

@implementation Filters

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.offeringDeal = NO;
        self.radius = 0;
        self.sort = 0;
        self.selectedCategories = [NSMutableSet set];
    }
    
    return self;
}

- (NSString *)categoryFilter {
    return [self.selectedCategories.allObjects componentsJoinedByString:@","];
}

- (id)copyWithZone:(NSZone *)zone {
    Filters *copy = [[Filters alloc] init];
    
    if (copy) {
        copy.offeringDeal = self.offeringDeal;
        copy.radius = self.radius;
        copy.sort = self.sort;
        copy.selectedCategories = [self.selectedCategories copyWithZone:zone];
    }
    
    return copy;
}

- (void)setSelectedCategories:(NSSet *)selectedCategories {
    if (_selectedCategories != selectedCategories) {
        _selectedCategories = [selectedCategories mutableCopy];
    }
}

@end
