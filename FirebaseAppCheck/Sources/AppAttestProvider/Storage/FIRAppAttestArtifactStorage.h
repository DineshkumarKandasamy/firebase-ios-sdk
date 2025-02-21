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

#import <Foundation/Foundation.h>

@class FBLPromise<ValueType>;

NS_ASSUME_NONNULL_BEGIN

/// Defines API of a storage capable to store an encrypted artifact required to refresh Firebase App
/// Check token obtained with App Attest provider.
@protocol FIRAppAttestArtifactStorageProtocol <NSObject>

/// Set the artifact. An artifact previously set for *any* key ID will be replaced by the new one
/// with the new key ID. The storage always stores a single artifact.
/// @param artifact The artifact data to store. Pass `nil` to remove the stored artifact.
/// @param keyID The App Attest key ID used to generate the artifact.
/// @return An artifact that is resolved with the artifact data passed into the method in case of
/// success or is rejected with an error.
- (FBLPromise<NSData *> *)setArtifact:(nullable NSData *)artifact forKey:(NSString *)keyID;

/// Get the artifact.
/// @param keyID The App Attest key ID used to generate the artifact.
/// @return A promise that is resolved with the artifact data if artifact exists, is resolved with
/// `nil` if no artifact found (or the existing artifact was set for a different key ID)  or is
/// rejected with an error.
- (FBLPromise<NSData *> *)getArtifactForKey:(NSString *)keyID;

@end

/// An implementation of FIRAppAttestArtifactStorageProtocol.
@interface FIRAppAttestArtifactStorage : NSObject <FIRAppAttestArtifactStorageProtocol>

- (instancetype)init NS_UNAVAILABLE;

/// A default initializer.
/// @param appName A Firebase App name (`FirebaseApp.name`). The app name will be used as a part of
/// the key to store the token for the storage instance.
/// @param appID A Firebase App identifier (`FirebaseOptions.googleAppID`). The app ID will be used
/// as a part of the key to store the token for the storage instance.
/// @param accessGroup The Keychain Access Group.
- (instancetype)initWithAppName:(NSString *)appName
                          appID:(NSString *)appID
                    accessGroup:(nullable NSString *)accessGroup;
@end

NS_ASSUME_NONNULL_END
