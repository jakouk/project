//
//  CustomCollectionCell.h
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 15..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionCell : UICollectionViewCell {
    
    UIImageView *imageView;
    
}

@property (nonatomic, retain) UIImageView *imageView; //this imageview is the only thing we need right now.


@end
