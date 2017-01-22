//
//  JEBObjectLabel.m
//  jeb
//
//  Created by Joyce Yan on 1/21/17.
//  Copyright © 2017 Joyce Yan. All rights reserved.
//

#import "JEBObjectLabel.h"

NSString *const JEBLabelFont = @"Avenir";

@implementation JEBObjectLabel

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame])
  {
    // Update the UI of the label.
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.85f;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    // Round the corners.
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    
    // Update the font.
    UIFont *font = [UIFont fontWithName:JEBLabelFont size:18];
    self.titleLabel.font = font;
  }
  return self;
}

@end
