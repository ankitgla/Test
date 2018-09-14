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

#define PHOTO_URL @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=%@&page=%lu"

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
    NSString* urlString = [NSString stringWithFormat:@"http://farm%ld.static.flickr.com/%@/%@_%@_q.jpg", photo.farm, photo.server, photo.photoID, photo.secret];
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
