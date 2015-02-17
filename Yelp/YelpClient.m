//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self searchWithTerm:term filters:nil offset:0 success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term filters:(Filters *)filters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self searchWithTerm:term filters:filters offset:0 success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term filters:(Filters *)filters offset:(NSInteger)offset success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    CLLocationCoordinate2D location;
    location.latitude = 37.774866;
    location.longitude = -122.394556;
    return [self searchWithTerm:term filters:filters offset:offset location:location success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term filters:(Filters *)filters offset:(NSInteger)offset location:(CLLocationCoordinate2D)location success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:term forKey:@"term"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude] forKey:@"ll"];
    if (filters) {
        if (filters.offeringDeal) {
            [parameters setObject:@YES forKey:@"deals_filter"];
        }
        if (filters.radius > 0) {
            [parameters setObject:[NSNumber numberWithInteger:filters.radius] forKey:@"radius_filter"];
        }
        [parameters setObject:[NSNumber numberWithInteger:filters.sort] forKey:@"sort"];
        if (filters.selectedCategories.count) {
            [parameters setObject:filters.categoryFilter forKey:@"category_filter"];
        }
    }
    if (offset) {
        [parameters setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    }
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
