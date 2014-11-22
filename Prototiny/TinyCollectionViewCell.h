//
//  TinyCollectionViewCell.h
//  Prototiny
//
//  Created by Eduardo Diaz Sancha on 11/21/14.
//  Copyright (c) 2014 Eduardo Diaz Sancha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TinyCollectionViewCell : UICollectionViewCell

- (void)setVideoURL:(NSString *)url;

- (void)pauseVideo;

- (void)playVideo;

@end
