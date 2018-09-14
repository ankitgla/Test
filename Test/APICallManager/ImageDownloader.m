//
//  ImageDownloader.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "ImageDownloader.h"
#import "Photo.h"
#import "NetworkQueueManager.h"

#define PHOTO_URL @"http://farm%ld.static.flickr.com/%@/%@_%@_q.jpg"

@interface ImageDownloader ()
@property (nonatomic, strong) NSMutableArray *imageDownloadsInProgress;
@end

@implementation ImageDownloader

+ (instancetype)sharedInstance {
    static ImageDownloader *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[ImageDownloader alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageDownloadsInProgress = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void) downloadImageFor:(Photo*) photo forIndexPath:(NSIndexPath*) indexPath {
    NSString* urlString = [NSString stringWithFormat:PHOTO_URL, photo.farm, photo.server, photo.photoID, photo.secret];
    if (![_imageDownloadsInProgress containsObject:urlString]) {
        [_imageDownloadsInProgress addObject:urlString];
        __weak typeof(self) weakself = self;
        [[NetworkQueueManager sharedInstance] makeRequest:urlString
                                              isImageCall:false
                                           withCompletion:^(NSData *data, NSError *error) {
                                               if (error == nil) {
                                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                                   if (weakself.completionHandler != nil) {
                                                       weakself.completionHandler(image, indexPath);
                                                   }
                                               }
                                               [weakself.imageDownloadsInProgress removeObject:urlString];
                                           }];
    }
}

@end
