//
//  SearchCall.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoData.h"

@interface PhotoSearchCall : NSObject

@property (nonatomic, copy) void (^completionHandler)(PhotoData* data);

- (void) searchForKeyWord:(NSString*) keyWord;
- (void) loadNextPage;
- (BOOL) isPhotoSearchCallInProgress;
- (NSUInteger) getCurrentPageNo;

@end
