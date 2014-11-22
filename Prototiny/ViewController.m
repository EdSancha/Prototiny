//
//  ViewController.m
//  Prototiny
//
//  Created by Eduardo Diaz Sancha on 11/21/14.
//  Copyright (c) 2014 Eduardo Diaz Sancha. All rights reserved.
//

#import "ViewController.h"
#import "TinyCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, retain) AVPlayerItem *mPlayerItem;
@property (nonatomic, retain) AVPlayer *mPlayer;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isFirstView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(106, 106)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing =0;
    [self.collectionView setCollectionViewLayout:flowLayout];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isFirstView = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 128;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TinyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TinyCollectionViewCell" forIndexPath:indexPath];
    
//    [cell setVideoURL:@"http://v.cdn.vine.co/r/videos/B1CC10903F1128173719328862208_207e7058bcb.5.1.16279578732074365577.mp4"];
    [cell setVideoURL:@"http://edsancha.com/img/others/Doggie.mp4"];
    
    
    if (self.isFirstView && indexPath.row < 16) {
        [cell playVideo];
    } else {
        self.isFirstView = NO;
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(self.collectionView.frame.size.width / 3 , self.collectionView.frame.size.width / 3);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UIScrollViewDelegate 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {   // called on finger up as we are moving
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollMoved" object:nil];
    
    for (TinyCollectionViewCell *cell in self.collectionView.visibleCells) {
        [cell pauseVideo];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStopped" object:nil];
        
        for (TinyCollectionViewCell *cell in self.collectionView.visibleCells) {
            [cell playVideo];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStopped" object:nil];
    
    for (TinyCollectionViewCell *cell in self.collectionView.visibleCells) {
        [cell playVideo];
    }
}



@end
