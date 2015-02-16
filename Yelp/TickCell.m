//
//  TickCell.m
//  Yelp
//
//  Created by Kittipat Virochsiri on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "TickCell.h"

@interface TickCell()

@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (nonatomic, strong) UIImage *circleImage;
@property (nonatomic, strong) UIImage *checkedImage;

@end

@implementation TickCell

- (void)awakeFromNib {
    self.circleImage = [[UIImage imageNamed:@"circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.checkedImage = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.checkImage.tintColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO completion:nil];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (self.on == on) {
        animated = NO;
    }
    _on = on;
    NSTimeInterval interval = animated ? 0.3 : 0.0;
    [UIView transitionWithView:self.checkImage duration:interval options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.checkImage.tintColor = self.on ? [[[UIApplication sharedApplication] keyWindow] tintColor] : [UIColor lightGrayColor];
        self.checkImage.image = self.on ? self.checkedImage : self.circleImage;
    } completion:completion];
}

@end
