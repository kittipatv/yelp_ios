//
//  Business.m
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
        
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        NSArray *displayAddress = [dictionary valueForKeyPath:@"location.display_address"];
        if (displayAddress.count > 2) {
            NSRange range;
            range.length = 2;
            range.location = 0;
            displayAddress = [displayAddress subarrayWithRange:range];
        }
        self.address = [displayAddress componentsJoinedByString:@", "];
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[dictionary valueForKeyPath:@"location.coordinate.latitude"] doubleValue];
        coordinate.longitude = [[dictionary valueForKeyPath:@"location.coordinate.longitude"] doubleValue];
        self.myCenter = coordinate;
        NSLog(@"coordinate %f, %f", coordinate.latitude, coordinate.longitude);
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    return businesses;
}

- (NSString *)title {
    return self.name;
}

- (CLLocationCoordinate2D)coordinate {
    return self.myCenter;
}

@end
