//
//  MainViewController.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
<UICollectionViewDelegate, UICollectionViewDataSource>

//스토리보드 컬렉션뷰
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property NSArray *item;

@end
