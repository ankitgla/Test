//
//  Photo.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype) initWithDict:(NSDictionary*) dict {
    self = [super init];

    if (self) {
        _photoID = [dict objectForKey:@"id"];
        _owner = [dict objectForKey:@"owner"];
        _secret = [dict objectForKey:@"secret"];
        _server = [dict objectForKey:@"server"];
        _farm = [[dict objectForKey:@"farm"] integerValue];
        _title = [dict objectForKey:@"title"];
        _ispublic = [[dict objectForKey:@"ispublic"] integerValue];
        _isfriend = [[dict objectForKey:@"isfriend"] integerValue];
        _isfamily = [[dict objectForKey:@"isfamily"] integerValue];
    }
    return self;
}

@end
