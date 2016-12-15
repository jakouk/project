//
//  CustomCollectionCell.m
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 15..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "CustomCollectionCell.h"

@implementation CustomCollectionCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        imageView = [[UIImageView alloc] init];
        imageView.frame = aRect;
        [self.contentView addSubview:imageView];
        
    }
    return self;
}

@end
