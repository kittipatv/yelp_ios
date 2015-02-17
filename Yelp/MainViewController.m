//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"

#import <MapKit/MapKit.h>

#import "Business.h"
#import "BusinessCell.h"
#import "Filters.h"
#import "FiltersViewController.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) UIView *activeView;
@property (nonatomic, strong) UIView *inactiveView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, strong) BusinessCell *prototypeBusinessCell;
@property (nonatomic, strong) Filters *filters;
@property (nonatomic, assign) BOOL loadingData;
@property (nonatomic, assign) BOOL reachedBottom;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)searchWithText:(NSString *)text {
    self.loadingData = YES;
    
    [self.client searchWithTerm:text filters:self.filters offset:0 location:self.locationManager.location.coordinate success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.businesses setArray:[Business businessesWithDictionaries:businessDictionaries]];
        [self.mapView addAnnotations:self.businesses];
        [self animateTable];
        self.loadingData = NO;
        self.reachedBottom = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        self.loadingData = NO;
    }];
}

- (void)animateTable {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.businesses = [NSMutableArray array];
    self.filters = [[Filters alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Yelp";
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onViewButton)];
    
    self.prototypeBusinessCell = [[BusinessCell alloc] init];
    
    self.loadingData = NO;
    self.reachedBottom = NO;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"requesting permissions");
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.rotateEnabled = YES;
    
    self.activeView = self.tableView;
    self.inactiveView = self.mapView;
    
    [self.mapView removeFromSuperview];
    
    [self searchWithText:@""];
}

- (void) hideKeyboard {
    [self.searchBar resignFirstResponder];
}

- (void)onFilterButton {
    NSLog(@"filters");
    FiltersViewController *vc = [[FiltersViewController alloc] initWithFilters:self.filters];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onViewButton {
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        UIView *temp = self.activeView;
        self.activeView = self.inactiveView;
        self.inactiveView = temp;

        [self.inactiveView removeFromSuperview];
        [self.view addSubview:self.activeView];
        
        NSDictionary *viewDictionary = @{@"activeView":self.activeView};
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[activeView]-0-|" options:0 metrics:nil views:viewDictionary];
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[activeView]-0-|" options:0 metrics:nil views:viewDictionary];
        [self.view addConstraints:verticalConstraints];
        [self.view addConstraints:horizontalConstraints];
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationItem.rightBarButtonItem.title = self.inactiveView == self.mapView ? @"Map" : @"List";
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location updated %@", userLocation);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(Filters *)filters {
    NSLog(@"self.filters %@", self.filters);
    NSLog(@"filters %@", filters);
    NSLog(@"Fire new network event");
    self.filters = filters;
    [self searchWithText:self.searchBar.text];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeBusinessCell.business = self.businesses[indexPath.row];
    CGSize size = [self.prototypeBusinessCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.businesses.count - 1 && !self.reachedBottom && !self.loadingData) {
        [self loadMoreData];
    }
    
    BusinessCell *cell = (BusinessCell *)[self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)loadMoreData {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;
    
    [self.client searchWithTerm:self.searchBar.text filters:self.filters offset:self.businesses.count success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        if (businessDictionaries.count) {
            [self.businesses addObjectsFromArray:[Business businessesWithDictionaries:businessDictionaries]];
            [self.tableView reloadData];
        } else {
            self.reachedBottom = YES;
        }
        self.loadingData = NO;
        [self.tableView.tableFooterView removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        self.reachedBottom = YES;
        self.loadingData = NO;
        [self.tableView.tableFooterView removeFromSuperview];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
