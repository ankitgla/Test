//
//  PhotoData.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData

- (instancetype) initWithDict:(NSDictionary*) dict {
    self = [super init];
    
    if (self) {
        _totalRecords = [dict objectForKey:@"total"];
        _currentPage = [[dict objectForKey:@"page"] integerValue];
        _totalPage = [[dict objectForKey:@"pages"] integerValue];
        _perPage = [[dict objectForKey:@"perpage"] integerValue];
        
        NSArray* tempPhoto = [dict objectForKey:@"photo"];
        if(tempPhoto.count != 0) {
            _photoList = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary* photoValue in tempPhoto) {
                [_photoList addObject:[[Photo alloc] initWithDict:photoValue]];
            }
        }
    }
    return self;
}

@end
