//
// Copyright (c) 2019 Emarsys. All rights reserved.
//
#import "EMSLoggingMobileEngageInternal.h"
#import "EMSMethodNotAllowed.h"
#import "EMSMacros.h"
#import "Emarsys.h"

#define klass [Emarsys class]

@implementation EMSLoggingMobileEngageInternal

- (void)setAuthorizedContactWithContactFieldValue:(nullable NSString *)contactFieldValue
                                          idToken:(nullable NSString *)idToken
                                  completionBlock:(_Nullable EMSCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"contactFieldValue"] = contactFieldValue;
    parameters[@"idToken"] = idToken;
    parameters[@"completionBlock"] = @(completionBlock != nil);

    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:parameters], LogLevelDebug);
}

- (void)setContactWithContactFieldValue:(nullable NSString *)contactFieldValue {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"contactFieldValue"] = contactFieldValue;
    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:parameters], LogLevelDebug);
}

- (void)setContactWithContactFieldValue:(nullable NSString *)contactFieldValue
                        completionBlock:(_Nullable EMSCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"contactFieldValue"] = contactFieldValue;
    parameters[@"completionBlock"] = @(completionBlock != nil);

    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:parameters], LogLevelDebug);
}

- (void)clearContact {
    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:nil], LogLevelDebug);
}

- (void)clearContactWithCompletionBlock:(_Nullable EMSCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"completionBlock"] = @(completionBlock != nil);
    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:parameters], LogLevelDebug);
}

- (void)trackCustomEventWithName:(NSString *)eventName
                 eventAttributes:(nullable NSDictionary<NSString *, NSString *> *)eventAttributes {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"eventName"] = eventName;
    parameters[@"eventAttributes"] = eventAttributes;
    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:parameters], LogLevelDebug);
}

- (void)trackCustomEventWithName:(NSString *)eventName
                 eventAttributes:(nullable NSDictionary<NSString *, NSString *> *)eventAttributes
                 completionBlock:(_Nullable EMSCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"eventName"] = eventName;
    parameters[@"eventAttributes"] = eventAttributes;
    parameters[@"completionBlock"] = @(completionBlock != nil);
    EMSLog([[EMSMethodNotAllowed alloc] initWithClass:klass
                                                  sel:_cmd
                                           parameters:parameters], LogLevelDebug);
}


@end