//
//  NetworkOperation.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "NetworkOperation.h"

@interface NetworkOperation ()

@property (nonatomic, weak) NSString* urlString;
@property (nonatomic, copy) void (^completion)(NSData* data, NSError* error);

@end

@implementation NetworkOperation

- (instancetype) initWithURLString:(NSString*) urlString
                 withCompletion:(void (^)(NSData* data, NSError* error))completion {
    self = [super init];
    
    if (self) {
        self.urlString = urlString;
        self.completion = completion;
    }
    return self;
}

- (void)start
{
    [super start];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      if (self.completion) {
                                          self.completion(data, error);
                                      }
                                  }];
    
    [task resume];
}

@end
