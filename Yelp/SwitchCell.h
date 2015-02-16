//
//  SwitchCell.h
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (nonatomic, assign) BOOL on;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
