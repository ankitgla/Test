//
//  CollectionCell.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

typedef enum : NSUInteger {
    kDefault, //With Image
    kNoResult,
    kCallInProgress,
    kENDOFResult,
} ViewType;

@interface CollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) updateView:(ViewType) type withPhoto:(Photo*) photo;

@end
