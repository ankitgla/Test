//
//  NetworkQueueManager.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "NetworkQueueManager.h"
#import "NetworkOperation.h"
#import "ImageDownloader.h"

@interface NetworkQueueManager ()
@property (nonatomic, strong) NSOperationQueue *queue;
@property (atomic, strong) NSCache *searchCallCache;
@property (atomic, strong) NSCache *imageCache;
@end

@implementation NetworkQueueManager

+ (instancetype)sharedInstance {
    static NetworkQueueManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
                      sharedInstance = [[NetworkQueueManager alloc] init];
                  });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
        self.searchCallCache = [[NSCache alloc] init];
        self.imageCache = [[NSCache alloc] init];
    }
    
    return self;
}

- (void)addOperation:(NSOperation *)operation {
    [self.queue addOperation:operation];
}

- (void) cancelAllOperation {
    [self.queue.operations enumerateObjectsUsingBlock:^(NSOperation* obj, NSUInteger idx, BOOL* stop) {
        [obj cancel];
    }];
    [self.imageCache removeAllObjects];
    [self.searchCallCache removeAllObjects];    
}

- (void) makeRequest:(NSString*) urlString
         isImageCall:(BOOL) isImage
      withCompletion:(void (^)(NSData* data, NSError* error))completion {
    
    NSData* tempData = isImage ? [self.imageCache objectForKey:urlString] : [self.searchCallCache objectForKey:urlString];
    if (tempData != nil)
        completion(tempData, nil);
    else {
        NetworkOperation *operation = [[NetworkOperation alloc] initWithURLString:urlString withCompletion:^(NSData *data, NSError *error) {
            if (error == nil) {
                if (isImage) {
                    [self.imageCache setObject:data forKey:urlString];
                } else {
                    [self.searchCallCache setObject:data forKey:urlString];
                }
            }
            completion(data, error);
        }];
        
        [[NetworkQueueManager sharedInstance] addOperation:operation];
    }
}

@end
