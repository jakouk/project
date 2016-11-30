//
//  WriteViewController.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface WriteViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, copy) NSMutableArray *chosenImages;
@property (nonatomic) NSMutableArray *chosenImages;

// the default picker controller
- (IBAction)launchController;

// a special picker controller that limits itself to a single album, and lets the user
// pick just one image from that album.
- (IBAction)launchSpecialController;


@end
