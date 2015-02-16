//
//  DropDownCell.m
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DropDownCell.h"

@interface DropDownCell()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end

@implementation DropDownCell

- (void)awakeFromNib {
    self.arrowImage.image = [self.arrowImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
