//
//  TickCell.m
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "TickCell.h"

@interface TickCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation TickCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    _on = on;
    self.statusLabel.text = self.on ? @"√" : @"";
}

@end
