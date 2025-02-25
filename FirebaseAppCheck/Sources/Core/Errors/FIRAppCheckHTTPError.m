/*
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FirebaseAppCheck/Sources/Core/Errors/FIRAppCheckHTTPError.h"

#import "FirebaseAppCheck/Sources/Core/Errors/FIRAppCheckErrorUtil.h"

@implementation FIRAppCheckHTTPError

- (instancetype)initWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse
                                data:(nullable NSData *)data {
  NSDictionary *userInfo = [[self class] userInfoWithHTTPResponse:HTTPResponse data:data];
  self = [super initWithDomain:kFIRAppCheckErrorDomain
                          code:FIRAppCheckErrorCodeUnknown
                      userInfo:userInfo];
  if (self) {
    _HTTPResponse = HTTPResponse;
    _data = data;
  }
  return self;
}

+ (NSDictionary *)userInfoWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse
                                      data:(nullable NSData *)data {
  NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSString *failureReason =
      [NSString stringWithFormat:@"The server responded with an error: \n - URL: %@ \n - HTTP "
                                 @"status code: %ld \n - Response body: %@",
                                 HTTPResponse.URL, (long)HTTPResponse.statusCode, responseString];
  return @{NSLocalizedFailureReasonErrorKey : failureReason};
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] alloc] initWithHTTPResponse:self.HTTPResponse data:self.data];
}

#pragma mark - NSSecureCoding

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
  NSHTTPURLResponse *HTTPResponse = [coder decodeObjectOfClass:[NSHTTPURLResponse class]
                                                        forKey:@"HTTPResponse"];
  if (!HTTPResponse) {
    return nil;
  }
  NSData *data = [coder decodeObjectOfClass:[NSData class] forKey:@"data"];

  return [self initWithHTTPResponse:HTTPResponse data:data];
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.HTTPResponse forKey:@"HTTPResponse"];
  [coder encodeObject:self.data forKey:@"data"];
}

+ (BOOL)supportsSecureCoding {
  return YES;
}

@end
