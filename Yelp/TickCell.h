//
//  TickCell.h
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
