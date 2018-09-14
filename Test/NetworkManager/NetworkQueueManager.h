//
//  NetworkQueueManager.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkQueueManager : NSObject

+ (instancetype)sharedInstance;
- (void) cancelAllOperation;
- (void) makeRequest:(NSString*) urlString
         isImageCall:(BOOL) isImage
      withCompletion:(void (^)(NSData* data, NSError* error))completion;
@end
