//
//  CollectionCell.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "CollectionCell.h"
#import "Photo.h"

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 1;
}

- (void) updateView:(ViewType) type withPhoto:(Photo*) photo {
    if (type == kDefault) {
        _textLabel.hidden = YES;
        _imageView.hidden = NO;
        if (photo.photoImage) {
            _imageView.image = photo.photoImage;
            _activityIndicator.hidden = YES;
            [_activityIndicator stopAnimating];
        } else {
            _imageView.image = nil;
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
        }
    } else {
        _textLabel.hidden = NO;
        _imageView.hidden = YES;
        _activityIndicator.hidden = YES;
        if (type == kENDOFResult) {
            _textLabel.text = @"End of result";
        } else if (type == kCallInProgress) {
            _textLabel.text = @"Call in progress";
        } else if (type == kNoResult) {
            _textLabel.text = @"No Result";
        }
    }
}

@end
