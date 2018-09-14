//
//  Photo.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Photo : NSObject

@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * secret;
@property (nonatomic, retain) NSString * server;
@property (nonatomic, assign) NSUInteger farm;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, assign) NSUInteger ispublic;
@property (nonatomic, assign) NSUInteger isfriend;
@property (nonatomic, assign) NSUInteger isfamily;
@property (nonatomic, retain) UIImage *photoImage;

- (instancetype) initWithDict:(NSDictionary*) dict;

@end
