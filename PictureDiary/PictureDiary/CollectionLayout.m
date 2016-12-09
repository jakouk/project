//
//  CollectionLayout.m
//  PictureDiary
//
//  Created by geon hui kim on 2016. 12. 6..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "CollectionLayout.h"
#import "MainViewController.h"

@interface CollectionLayout ()

@property (nonatomic, weak) id <CollectionLayout> delegate;

@end

@implementation CollectionLayout

- (id <CollectionLayout> )delegate
{
    return (id <CollectionLayout> )self.collectionView.delegate;
}

//
-(id)initWithMaxRatio:(CGFloat)maxR andMinRatio:(CGFloat)minR
{
    if ((self = [super init]) != NULL)
    {
        self.maxRatio = maxR; //420.0f;
        self.minRatio = minR; //(CGSize){ 220.0f, 80.0f };
        [self setup];
    }
    return self;
}

- (void)setup
{
    
}

//레이아웃 준비
- (void)prepareLayout
{
    [super prepareLayout];
    //셀 갯수
    self.cellCount = (int)[self.collectionView numberOfItemsInSection:0];
    //셀의 최대 넓이
    self.maxHeight = self.collectionView.bounds.size.width / self.maxRatio;
    //셀의 최소 넓이
    self.minHeight = self.collectionView.bounds.size.width / self.minRatio;
    //셀 사이의 간격
    self.cellHeight = (self.maxHeight * 0.6 + self.minHeight * 0.6);
    
    //    NSLog(@" layout Controller maxratio : %lf, minratio : %lf", self.maxRatio, self.minRatio);
}

//기하학적인 레이아웃을 재쿼리 할수있다. yes일경우
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

//지정된 구석의 모든 뷰에 대해 배열 레이아웃 속성 인스턴스를 리턴합니다.
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *theLayoutAttributes = [NSMutableArray array];
    
    //시작 0 이면 공백없이 첫번째 사진부터 시작
    float firstItem = 0;//fmax(0 , floorf(minY / self.itemHeight) - 4 );
    //끝 self.cellCount - 1 이면 마지막 사진이 끝 공백없음
    float lastItem = self.cellCount - 1;//fmin( self.cellCount-1 , floorf(maxY / self.itemHeight) );
    
    for( NSInteger i = firstItem; i <= lastItem; i++ ){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
    
    if ([self.delegate respondsToSelector:@selector(layoutSubviewsWithAttributes:)]) {
        [self.delegate layoutSubviewsWithAttributes:theLayoutAttributes];
    }
    
    return theLayoutAttributes;
}

//컬렉션뷰의 내용,크기,너비를 오버라이드한다.
- (CGSize)collectionViewContentSize
{
    const CGSize theSize = {
        .width = self.collectionView.bounds.size.width,
        .height = (self.cellCount - 1) * self.cellHeight + self.collectionView.bounds.size.height,
    };
    return theSize;
}

//스크롤하면서 컬렉션뷰 레이아웃 조절
//Make sure your MaxRatio is bigger than your Images ratio to avoid a sudden jump during the resizing of the Cell
//셀 크기가 조정되는 동안 갑자기 점프되는 것을 방지하려면 MaxRatio가 이미지 비율보다 큰지 확인하십시오.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat currentIndex = self.collectionView.contentOffset.y / self.cellHeight;
    
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttributes.center = CGPointMake(self.collectionView.center.x , self.maxHeight * 0.5); //테이블뷰 위 공백이 생김 0.5보다 높으면
    
    CGAffineTransform translationT;
    
    //컬렉션뷰 위쪽 오프셋
    CGFloat endTranslateOffset = 0;
    
    CGFloat endFactor1 = (self.collectionView.bounds.size.height - self.maxHeight) / self.minHeight;
    if(currentIndex + 1 > (self.cellCount - endFactor1)){
        CGFloat valA = (currentIndex + 1 - (self.cellCount - endFactor1));
        CGFloat valB = valA / endFactor1;
        endTranslateOffset = (self.collectionView.bounds.size.height - self.maxHeight) * valB;
    }
    
    //     CGFloat endTranslateOffset = 0;
    //     CGFloat lastItemY = (self.cellHeight * (self.cellCount - 1))  - self.collectionView.bounds.size.height;
    //
    //     if(self.collectionView.contentOffset.y > lastItemY){
    //     CGFloat maxEnd = self.collectionView.contentSize.height - lastItemY;
    //     CGFloat factorEnd = (self.collectionView.contentOffset.y - lastItemY) / maxEnd;
    //     endTranslateOffset = factorEnd * self.collectionView.bounds.size.height;
    //     }
    
    //올릴때
    //====================================================================================================================================
    if(indexPath.item > floor(currentIndex) && indexPath.item <= floor(currentIndex) + 1 ){
        
        CGFloat factorY = floor(currentIndex) + 1 - currentIndex;
        CGFloat factorSize = fabs(1 - factorY);
        
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight + (factorSize * (self.maxHeight - self.minHeight) ));
        
        translationT = CGAffineTransformMakeTranslation(0, endTranslateOffset + self.collectionView.contentOffset.y + self.cellHeight * factorY);
        
    //====================================================================================================================================
    }else if(indexPath.item >= floor(currentIndex) + 1){
        
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset+ self.collectionView.contentOffset.y +self.cellHeight +  (self.minHeight * fmax(0, ((float)indexPath.item-currentIndex-1))) );
        
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight);
        
    //내릴때
    //====================================================================================================================================
    }else if (indexPath.item <= floor(currentIndex) && indexPath.item > floor(currentIndex) - 1){
        
        CGFloat factorY = 1 - (floor(currentIndex) + 1 - currentIndex);
        CGFloat factorSize = fabs(1 - factorY);
        
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight + (factorSize * (self.maxHeight - self.minHeight) ));
        
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset + self.collectionView.contentOffset.y - self.cellHeight * factorY);
        
    //====================================================================================================================================
    }else if(indexPath.item <= floor(currentIndex) - 1){
        
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight);
        
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset + self.collectionView.contentOffset.y - self.cellHeight +  (self.minHeight * fmin(0, ((float)indexPath.item-currentIndex+1))) );
    }
    
    //
    theAttributes.transform = translationT;
    theAttributes.zIndex = 1;
    return(theAttributes);
}

@end
