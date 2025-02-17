//
//  Copyright © 2018. Emarsys. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "Kiwi.h"
#import "EMSRequestManager.h"
#import "MERequestContext.h"
#import "EMSConfigInternal.h"
#import "EMSAppStartBlockProvider.h"
#import "EMSDeviceInfo+MEClientPayload.h"
#import "EMSRequestFactory.h"
#import "EMSUUIDProvider.h"
#import "EMSDeviceInfoClientProtocol.h"
#import "EMSGeofenceInternal.h"
#import "EMSStorage.h"
#import "EMSSdkStateLogger.h"
#import "EMSLogger.h"

@interface EMSAppStartBlockProviderTests : XCTestCase

@property(nonatomic, strong) EMSRequestManager *mockRequestManager;
@property(nonatomic, strong) MERequestContext *requestContext;
@property(nonatomic, strong) EMSAppStartBlockProvider *appStartBlockProvider;
@property(nonatomic, strong) EMSRequestFactory *mockRequestFactory;
@property(nonatomic, strong) EMSConfigInternal *mockConfigInternal;
@property(nonatomic, strong) id mockDeviceInfoClient;
@property(nonatomic, strong) MERequestContext *mockRequestContext;
@property(nonatomic, strong) MEHandlerBlock appStartEventBlock;
@property(nonatomic, strong) NSString *applicationCode;
@property(nonatomic, strong) NSNumber *contactFieldId;
@property(nonatomic, strong) EMSGeofenceInternal *mockGeofenceInternal;
@property(nonatomic, strong) EMSStorage *mockStorage;
@property(nonatomic, strong) EMSSdkStateLogger *mockSdkStateLogger;
@property(nonatomic, strong) EMSLogger *mockLogger;

@end

@implementation EMSAppStartBlockProviderTests


- (void)setUp {
    _applicationCode = @"testApplicationCode";
    _contactFieldId = @3;
    _mockRequestManager = OCMClassMock([EMSRequestManager class]);
    _mockRequestFactory = OCMClassMock([EMSRequestFactory class]);
    _mockDeviceInfoClient = OCMProtocolMock(@protocol(EMSDeviceInfoClientProtocol));
    _mockRequestContext = OCMClassMock([MERequestContext class]);
    _mockConfigInternal = OCMClassMock([EMSConfigInternal class]);
    _mockGeofenceInternal = OCMClassMock([EMSGeofenceInternal class]);
    _mockStorage = OCMClassMock([EMSStorage class]);
    _requestContext = [[MERequestContext alloc] initWithApplicationCode:self.applicationCode
                                                           uuidProvider:[EMSUUIDProvider new]
                                                      timestampProvider:[EMSTimestampProvider new]
                                                             deviceInfo:[EMSDeviceInfo new]
                                                                storage:self.mockStorage];

    [self.requestContext setContactToken:nil];

    _mockSdkStateLogger = OCMClassMock([EMSSdkStateLogger class]);
    _mockLogger = OCMClassMock([EMSLogger class]);

    _appStartBlockProvider = [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                                       requestFactory:self.mockRequestFactory
                                                                       requestContext:self.requestContext
                                                                     deviceInfoClient:self.mockDeviceInfoClient
                                                                       configInternal:self.mockConfigInternal
                                                                     geofenceInternal:self.mockGeofenceInternal
                                                                       sdkStateLogger:self.mockSdkStateLogger
                                                                               logger:self.mockLogger];
    _appStartEventBlock = [self.appStartBlockProvider createAppStartEventBlock];
}

- (void)tearDown {
    [self.requestContext setContactToken:nil];
}

- (void)testInit_requestManager_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:nil
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when requestManager is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: requestManager");
    }
}

- (void)testInit_requestFactory_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:nil
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when requestFactory is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: requestFactory");
    }
}

- (void)testInit_requestContext_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:nil
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when requestContext is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: requestContext");
    }
}

- (void)testInit_deviceInfoClient_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:nil
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when deviceInfoClient is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: deviceInfoClient");
    }
}

- (void)testInit_configInternal_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:nil
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when configInternal is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: configInternal");
    }
}

- (void)testInit_geofenceInternal_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:nil
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when geofenceInternal is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: geofenceInternal");
    }
}

- (void)testInit_sdkStateLogger_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:nil
                                                          logger:self.mockLogger];
        XCTFail(@"Expected Exception when sdkStateLogger is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: sdkStateLogger");
    }
}

- (void)testInit_logger_mustNotBeNil {
    @try {
        [[EMSAppStartBlockProvider alloc] initWithRequestManager:self.mockRequestManager
                                                  requestFactory:self.mockRequestFactory
                                                  requestContext:self.mockRequestContext
                                                deviceInfoClient:self.mockDeviceInfoClient
                                                  configInternal:self.mockConfigInternal
                                                geofenceInternal:self.mockGeofenceInternal
                                                  sdkStateLogger:self.mockSdkStateLogger
                                                          logger:nil];
        XCTFail(@"Expected Exception when logger is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: logger");
    }
}

- (void)testCreateAppStartBlockWithRequestManagerRequestContext_shouldSubmitAppStartEvent_whenInvokingHandlerBlock {
    [self.requestContext setContactToken:@"testContactToken"];

    EMSRequestModel *requestModel = OCMClassMock([EMSRequestModel class]);

    OCMStub([self.mockRequestFactory createEventRequestModelWithEventName:@"app:start"
                                                          eventAttributes:[OCMArg any]
                                                                eventType:EventTypeInternal]).andReturn(requestModel);

    self.appStartEventBlock();

    OCMVerify([self.mockRequestFactory createEventRequestModelWithEventName:@"app:start"
                                                            eventAttributes:[OCMArg any]
                                                                  eventType:EventTypeInternal]);
    OCMVerify([self.mockRequestManager submitRequestModel:requestModel
                                      withCompletionBlock:[OCMArg any]]);
}

- (void)testCreateAppStartBlockWithRequestManagerRequestContext_shouldNotCallSubmit_whenThereIsNoContactToken {
    OCMReject([self.mockRequestManager submitRequestModel:[OCMArg any]
                                      withCompletionBlock:[OCMArg any]]);
    self.appStartEventBlock();
}

- (void)testCreateDeviceInfoEventBlock {
    _appStartEventBlock = [self.appStartBlockProvider createDeviceInfoEventBlock];

    self.appStartEventBlock();

    OCMVerify([self.mockDeviceInfoClient trackDeviceInfoWithCompletionBlock:nil];);
}

- (void)testCreateRemoteConfigEventBlock {
    _appStartEventBlock = [self.appStartBlockProvider createRemoteConfigEventBlock];

    self.appStartEventBlock();

    OCMVerify([self.mockConfigInternal refreshConfigFromRemoteConfigWithCompletionBlock:[OCMArg any]]);
}

- (void)testCreateRemoteConfigEventBlock_refreshConfigBlockInvocation_triggersSdkStateLogger {
    OCMStub([self.mockLogger logLevel]).andReturn(LogLevelTrace);
    OCMStub([self.mockConfigInternal refreshConfigFromRemoteConfigWithCompletionBlock:[OCMArg invokeBlock]]);
    _appStartEventBlock = [self.appStartBlockProvider createRemoteConfigEventBlock];

    self.appStartEventBlock();

    OCMVerify([self.mockSdkStateLogger log]);
}

- (void)testCreateRemoteConfigEventBlock_refreshConfigBlockInvocation_shouldNotTriggersSdkStateLogger {
    OCMReject([self.mockSdkStateLogger log]);

    OCMStub([self.mockLogger logLevel]).andReturn(LogLevelInfo);
    OCMStub([self.mockConfigInternal refreshConfigFromRemoteConfigWithCompletionBlock:[OCMArg invokeBlock]]);
    _appStartEventBlock = [self.appStartBlockProvider createRemoteConfigEventBlock];

    self.appStartEventBlock();
}

- (void)testCreateFetchGeofenceEventBlock {
    _appStartEventBlock = [self.appStartBlockProvider createFetchGeofenceEventBlock];

    self.appStartEventBlock();

    OCMVerify([self.mockGeofenceInternal fetchGeofences]);
}

@end