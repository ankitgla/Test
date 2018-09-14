//
//  PhotoData.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface PhotoData : NSObject

@property (nonatomic, retain) NSString * totalRecords;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, assign) NSUInteger perPage;
@property (nonatomic, retain) NSMutableArray * photoList;

- (instancetype) initWithDict:(NSDictionary*) dict;

@end
