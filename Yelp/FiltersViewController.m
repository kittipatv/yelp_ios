//
//  FiltersViewController.m
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"

#import "DropDownCell.h"
#import "SeeAllCell.h"
#import "SwitchCell.h"
#import "TickCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) NSArray *distances;
@property (nonatomic, assign) BOOL categoryExpanded;
@property (nonatomic, assign) BOOL sortExpanded;
@property (nonatomic, assign) BOOL distanceExpanded;
@property (nonatomic, assign) NSInteger selectedDistanceIndex;

- (void)initCategories;

@end

@implementation FiltersViewController

- (id)init {
    return [self initWithFilters:[[Filters alloc] init]];
}

- (id)initWithFilters:(Filters *)filters {
    self = [super init];
    
    if (self) {
        [self initCategories];
        self.filters = filters;
        [self initCategoryExpanded];
        self.sortExpanded = NO;
        self.sorts = @[@"Best match", @"Distance", @"Rating"];
        self.distanceExpanded = NO;
        self.distances =
        @[@{@"name":@"Best match", @"meters":@0},
          @{@"name":@"2 blocks", @"meters":@160},
          @{@"name":@"6 blocks", @"meters":@322},
          @{@"name":@"1 mile", @"meters":@1609},
          @{@"name":@"5 miles", @"meters":@8046}];
        [self initSelectedDistanceIndex];
    }
    
    return self;
}

- (void)initSelectedDistanceIndex {
    for (NSInteger index = 0; index < self.distances.count; ++index) {
        NSDictionary *distanceDictionary = self.distances[index];
        if ([distanceDictionary[@"meters"] integerValue] == self.filters.radius) {
            self.selectedDistanceIndex = index;
            break;
        }
    }
}

- (void)initCategoryExpanded {
    NSInteger maxSelectedIndex = -1;
    for (NSInteger index = 0; index < self.categories.count; ++index) {
        if ([self.filters.selectedCategories containsObject:self.categories[index][@"code"]]) {
            NSLog(@"selected %@", self.categories[index][@"code"]);
            maxSelectedIndex = index;
        }
    }
    self.categoryExpanded = maxSelectedIndex > 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Filters";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SeeAllCell" bundle:nil] forCellReuseIdentifier:@"SeeAllCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DropDownCell" bundle:nil] forCellReuseIdentifier:@"DropDownCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TickCell" bundle:nil] forCellReuseIdentifier:@"TickCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.distanceExpanded ? self.distances.count : 1;
        case 2:
            return self.sortExpanded ? self.sorts.count : 1;
        case 3:
            return self.categoryExpanded ? self.categories.count : 4;
        default:
            break;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Deals";
        case 1:
            return @"Distance";
        case 2:
            return @"Sort by";
        case 3:
            return @"Categories";
        default:
            break;
    }
    return @"No";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [self dealRow];
        case 1:
            return [self distanceCellForRow:indexPath.row];
        case 2:
            return [self sortCellForRow:indexPath.row];
        case 3:
            return [self categoryCellForRow:indexPath.row];
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (UITableViewCell *)dealRow {
    SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = @"Offering a deal";
    cell.on = self.filters.offeringDeal;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)distanceCellForRow:(NSInteger)row {
    return self.distanceExpanded
        ? [self tickCellWithText:self.distances[row][@"name"] on:row == self.selectedDistanceIndex]
        : [self dropDownCellWithText:self.distances[self.selectedDistanceIndex][@"name"]];
}

- (UITableViewCell *)sortCellForRow:(NSInteger)row {
    return self.sortExpanded
        ? [self tickCellWithText:self.sorts[row] on:row == self.filters.sort]
        : [self dropDownCellWithText:self.sorts[self.filters.sort]];
}

- (TickCell *)tickCellWithText:(NSString *)text on:(BOOL)on {
    TickCell *cell = (TickCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TickCell"];
    cell.titleLabel.text = text;
    cell.on = on;
    return cell;
}

- (DropDownCell *)dropDownCellWithText:(NSString *)text {
    DropDownCell *cell = (DropDownCell *)[self.tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
    cell.titleLabel.text = text;
    return cell;
}

- (UITableViewCell *)categoryCellForRow:(NSInteger)row {
    if (!self.categoryExpanded && row == 3) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"SeeAllCell"];
    }
    
    SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = self.categories[row][@"name"];
    cell.on = [self.filters.selectedCategories containsObject:self.categories[row][@"code"]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [self didSelectDeal:indexPath];
            break;
        case 1:
            [self didSelectDistanceAtIndexPath:indexPath];
            break;
        case 2:
            [self didSelectSortAtIndexPath:indexPath];
            break;
        case 3:
            [self didSelectCategoryAtIndexPath:indexPath];
            break;
            
        default:
            break;
    }
}

- (void)didSelectDeal:(NSIndexPath *)indexPath {
    SwitchCell *cell = (SwitchCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setOn:!cell.on animated:YES];
}

- (void)didSelectDistanceAtIndexPath:(NSIndexPath *)indexPath {
    if (self.distanceExpanded) {
        if (indexPath.row != self.selectedDistanceIndex) {
            [self clearPreviousCellAtIndexPath:[NSIndexPath indexPathForRow:self.selectedDistanceIndex inSection:indexPath.section]];
        }
        
        self.selectedDistanceIndex = indexPath.row;
        self.filters.radius = [self.distances[indexPath.row][@"meters"] integerValue];
        self.distanceExpanded = NO;
        
        [self animateSelectTickCellAtIndexPath:indexPath];
    } else {
        self.distanceExpanded = YES;
        [self animateSection:indexPath.section];
    }
}

- (void)didSelectSortAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sortExpanded) {
        if (indexPath.row != self.filters.sort) {
            [self clearPreviousCellAtIndexPath:[NSIndexPath indexPathForRow:self.filters.sort inSection:indexPath.section]];
        }
        
        self.filters.sort = indexPath.row;
        self.sortExpanded = NO;
        
        [self animateSelectTickCellAtIndexPath:indexPath];
    } else {
        self.sortExpanded = YES;
        [self animateSection:indexPath.section];
    }
}

- (void)clearPreviousCellAtIndexPath:(NSIndexPath *)indexPath {
    TickCell *previousCell = (TickCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    previousCell.on = NO;
}

- (void)animateSelectTickCellAtIndexPath:(NSIndexPath *)indexPath {
    TickCell *cell = (TickCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setOn:YES animated:YES completion:^(BOOL finished) {
        if (finished) {
            [self animateSection:indexPath.section];
        }
    }];
}

- (void)didSelectCategoryAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.categoryExpanded && indexPath.row == 3) {
        self.categoryExpanded = YES;
        [self animateSection:indexPath.section];
    } else {
        SwitchCell *cell = (SwitchCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell setOn:!cell.on animated:YES];
    }
}

- (void)animateSection:(NSInteger)section {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
}

- (void)switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:switchCell];
    switch (indexPath.section) {
        case 0:
            self.filters.offeringDeal = value;
            break;
        case 3:
            [self updateSelectedCategories:indexPath.row value:value];
            break;
        default:
            break;
    }
}

- (void)updateSelectedCategories:(NSInteger)index value:(BOOL)value {
    if (value) {
        [self.filters.selectedCategories addObject:self.categories[index][@"code"]];
    } else {
        [self.filters.selectedCategories removeObject:self.categories[index][@"code"]];
    }
}

- (void)initCategories {
    self.categories =
    @[@{@"name":@"Thai", @"code":@"thai"},
      @{@"name":@"Taiwanese", @"code":@"taiwanese"},
      @{@"name":@"Japanese", @"code":@"japanese"},
      @{@"name":@"Asian Fusion", @"code":@"asianfusion"},
      @{@"name":@"Italian", @"code":@"italian"},
      @{@"name":@"French", @"code":@"french"}
      ];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
