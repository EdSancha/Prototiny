//
//  TinyCollectionViewCell.m
//  Prototiny
//
//  Created by Eduardo Diaz Sancha on 11/21/14.
//  Copyright (c) 2014 Eduardo Diaz Sancha. All rights reserved.
//

#import "TinyCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"

@interface TinyCollectionViewCell ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) UIImageView *firstImage;

@end

@implementation TinyCollectionViewCell

- (void)setVideoURL:(NSString *)url {
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    [self.playerLayer setFrame:CGRectMake(0, 0, 124, 124)];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];

    [self.contentView.layer addSublayer:self.playerLayer];
    
    self.firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 124, 124)];
//    self.firstImage.image = [self thumbnailImageForVideo:[NSURL URLWithString:url] atTime:0];

    [self.contentView addSubview:self.firstImage];
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:
                                                  [NSURL  URLWithString:@"http://edsancha.com/img/others/Doggie2.png"]]];
        dispatch_sync(dispatch_get_main_queue(),^ {
            //run in main thread
            [weakSelf handleImage:image];
        });
    });
    
//    [self.player play];
    
}

-(void)handleImage:(UIImage*)image{
    self.firstImage.image = image;
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}


- (void)pauseVideo {
    [[self.player currentItem] seekToTime:kCMTimeZero];
    [self.player pause];
    self.firstImage.hidden = NO;


}

- (void)playVideo {
    [self.player play];
    self.firstImage.hidden = YES;

}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}

- (void) prepareForReuse {
    [self.player pause];
    // uncomment if the player not needed anymore
    // playerLayer.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.firstImage = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}


@end
