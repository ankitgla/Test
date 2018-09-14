//
//  SearchCall.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "PhotoSearchCall.h"
#import "NetworkQueueManager.h"
#import "PhotoData.h"

#define SEARCH_URL @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=%@&page=%lu"

@interface PhotoSearchCall ()
@property (nonatomic, weak) NSString* searchString;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, retain) PhotoData* searchData;
@property (nonatomic, assign) BOOL callInProgress;
@end

@implementation PhotoSearchCall

- (void) searchForKeyWord:(NSString*) keyWord {
    if (keyWord.length <= 0) {
        return;
    }
    
    self.searchString = keyWord;
    self.pageNo = 1;
    self.searchData = nil;
    [self makeNetworkCall];
}

- (void) loadNextPage {
    //As total record value is changing every time
    if (_pageNo == _searchData.totalPage)
        return;
    
    if (self.callInProgress)
        return;
    
    self.pageNo++;
    [self makeNetworkCall];
}

- (BOOL) isPhotoSearchCallInProgress {
    return self.callInProgress;
}

- (NSUInteger) getCurrentPageNo {
    return self.pageNo;
}

- (void) makeNetworkCall {
    NSString* urlString = [NSString stringWithFormat:SEARCH_URL, _searchString, _pageNo];    
    __weak typeof(self) weakself = self;
    self.callInProgress = YES;
    [[NetworkQueueManager sharedInstance] makeRequest:urlString
                                          isImageCall:false
                                       withCompletion:^(NSData *data, NSError *error) {
                                           if (error == nil) {
                                               weakself.callInProgress = NO;
                                               NSError* parsingError;
                                               NSDictionary *parsedDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                          options:NSJSONReadingMutableContainers
                                                                                                            error:&parsingError];
                                               if (parsingError == nil) {
                                                   NSDictionary* photos = [parsedDict valueForKey:@"photos"];
                                                   if (photos != nil) {
                                                       PhotoData * data = [[PhotoData alloc] initWithDict:photos];
                                                       //Need to update data for second call
                                                       if (weakself.searchData == nil) {
                                                           weakself.searchData = data;
                                                       } else {
                                                           //Update Previous Photo
                                                           NSMutableArray* previousPhoto = self.searchData.photoList;
                                                           [previousPhoto addObjectsFromArray:data.photoList];
                                                           data.photoList = previousPhoto;
                                                           weakself.searchData = data;
                                                       }
                                                       
                                                       if (weakself.completionHandler != nil) {
                                                           weakself.completionHandler(weakself.searchData);
                                                       }
                                                   }
                                               }
                                           }
                                       }];
}

@end
