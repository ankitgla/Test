//
//  NetworkOperation.h
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkOperation : NSOperation

- (instancetype) initWithURLString:(NSString*) urlString
                    withCompletion:(void (^)(NSData* data, NSError* error))completion;

@end
