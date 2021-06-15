//
// Copyright (c) 2020 Emarsys. All rights reserved.
//

#import "EMSLoggingGeofenceInternal.h"
#import "EMSMacros.h"
#import "EMSMethodNotAllowed.h"

#define proto @protocol(EMSGeofenceProtocol)

@implementation EMSLoggingGeofenceInternal

- (id <EMSEventHandler>)eventHandler {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
    return nil;
}

- (void)setEventHandler:(id <EMSEventHandler>)eventHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"eventHandler"] = @(eventHandler != nil);
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:parameters], LogLevelDebug);
}

- (void)setInitialEnterTriggerEnabled:(BOOL)enterInitialTriggerEnabled {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"enterInitialTriggerEnabled"] = @(enterInitialTriggerEnabled);
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:parameters], LogLevelDebug);
}

- (BOOL)initialEnterTriggerEnabled {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
    return NO;
}

- (void)requestAlwaysAuthorization {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
}

- (void)enable {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
}

- (void)enableWithCompletionBlock:(_Nullable EMSCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"completionBlock"] = @(completionBlock != nil);
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:parameters], LogLevelDebug);
}

- (void)disable {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
}

- (BOOL)isEnabled {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
    return NO;
}

- (void)fetchGeofences {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
}

- (void)registerGeofences {
    EMSLog([[EMSMethodNotAllowed alloc] initWithProtocol:proto
                                                     sel:_cmd
                                              parameters:nil], LogLevelDebug);
}

@end
