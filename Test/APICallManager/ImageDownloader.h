//
//  ImageDownloader.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Photo.h"

@interface ImageDownloader : NSObject

@property (nonatomic, copy) void (^completionHandler)(UIImage* data, NSIndexPath* indexPath);

+ (instancetype)sharedInstance;
- (void) downloadImageFor:(Photo*) photo forIndexPath:(NSIndexPath*) indexPath;

@end
