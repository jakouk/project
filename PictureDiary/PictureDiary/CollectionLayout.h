//
//  CollectionLayout.h
//  PictureDiary
//
//  Created by geon hui kim on 2016. 12. 1..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MainViewController.h"
@interface CollectionLayout : UICollectionViewLayout

@property (readwrite, nonatomic, assign) NSInteger cellCount;
@property (readwrite, nonatomic, assign) CGFloat maxRatio;
@property (readwrite, nonatomic, assign) CGFloat minRatio;
@property (readwrite, nonatomic, assign) CGFloat maxHeight;
@property (readwrite, nonatomic, assign) CGFloat minHeight;
@property (readwrite, nonatomic, assign) CGFloat cellHeight;

-(id)initWithMaxRatio: (CGFloat)maxR andMinRatio: (CGFloat)minR;

@end

@protocol CollectionLayout <UICollectionViewDelegate>

@required

- (void)layoutSubviewsWithAttributes:(NSMutableArray*)theAttributes;

@end
