//
//  WriteViewController.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface WriteViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate>

//seletedImages ( Dictionary )
@property NSMutableArray *seletedImages;

@end
