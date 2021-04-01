//
//  Copyright © 2019 Emarsys. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "EMSEndpoint.h"
#import "EMSValueProvider.h"
#import "EMSRemoteConfig.h"
#import "MEExperimental.h"
#import "EMSInnerFeature.h"

static NSString *const kClientServiceUrl = @"https://me-client.eservice.emarsys.netl";
static NSString *const kEventServiceUrl = @"https://mobile-events.eservice.emarsys.net";
static NSString *const kV3MessageInboxServiceUrl = @"https://me-inbox.eservice.emarsys.net";
static NSString *const kPredictUrl = @"https://recommender.scarabresearch.com";
static NSString *const kDeeplinkUrl = @"https://deep-link.eservice.emarsys.net/api/clicks";
static NSString *const kV2ServiceUrl = @"https://push.eservice.emarsys.net/api/mobileengage/v2/events/message_open";
static NSString *const kInboxUrl = @"https://me-inbox.eservice.emarsys.net/api/";
static NSString *const kApplicationCode = @"testApplicationCode";

@interface EMSEndpointTests : XCTestCase

@property(nonatomic, strong) EMSEndpoint *endpoint;
@property(nonatomic, strong) EMSValueProvider *mockClientServiceUrlProvider;
@property(nonatomic, strong) EMSValueProvider *mockEventServiceUrlProvider;
@property(nonatomic, strong) EMSValueProvider *mockPredictUrlProvider;
@property(nonatomic, strong) EMSValueProvider *mockDeeplinkUrlProvider;
@property(nonatomic, strong) EMSValueProvider *mockV2EventServiceUrlProvider;
@property(nonatomic, strong) EMSValueProvider *mockInboxUrlProvider;
@property(nonatomic, strong) EMSValueProvider *mockV3MessageInboxUrlProvider;

@end

@implementation EMSEndpointTests

- (void)setUp {
    _mockClientServiceUrlProvider = OCMClassMock([EMSValueProvider class]);
    _mockEventServiceUrlProvider = OCMClassMock([EMSValueProvider class]);
    _mockPredictUrlProvider = OCMClassMock([EMSValueProvider class]);
    _mockDeeplinkUrlProvider = OCMClassMock([EMSValueProvider class]);
    _mockV2EventServiceUrlProvider = OCMClassMock([EMSValueProvider class]);
    _mockInboxUrlProvider = OCMClassMock([EMSValueProvider class]);
    _mockV3MessageInboxUrlProvider = OCMClassMock([EMSValueProvider class]);

    OCMStub([self.mockClientServiceUrlProvider provideValue]).andReturn(kClientServiceUrl);
    OCMStub([self.mockEventServiceUrlProvider provideValue]).andReturn(kEventServiceUrl);
    OCMStub([self.mockPredictUrlProvider provideValue]).andReturn(kPredictUrl);
    OCMStub([self.mockDeeplinkUrlProvider provideValue]).andReturn(kDeeplinkUrl);
    OCMStub([self.mockV2EventServiceUrlProvider provideValue]).andReturn(kV2ServiceUrl);
    OCMStub([self.mockInboxUrlProvider provideValue]).andReturn(kInboxUrl);
    OCMStub([self.mockV3MessageInboxUrlProvider provideValue]).andReturn(kV3MessageInboxServiceUrl);

    _endpoint = [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                              eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                                   predictUrlProvider:self.mockPredictUrlProvider
                                                  deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                            v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                                     inboxUrlProvider:self.mockInboxUrlProvider
                                            v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
}

- (void)tearDown {
    [MEExperimental disableFeature:EMSInnerFeature.eventServiceV4];
}

- (void)testInit_clientServiceUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:nil
                                      eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                           predictUrlProvider:self.mockPredictUrlProvider
                                          deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                    v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                             inboxUrlProvider:self.mockInboxUrlProvider
                                    v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
        XCTFail(@"Expected Exception when clientServiceUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: clientServiceUrlProvider");
    }
}

- (void)testInit_eventServiceUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                      eventServiceUrlProvider:nil
                                           predictUrlProvider:self.mockPredictUrlProvider
                                          deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                    v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                             inboxUrlProvider:self.mockInboxUrlProvider
                                    v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
        XCTFail(@"Expected Exception when eventServiceUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: eventServiceUrlProvider");
    }
}

- (void)testInit_predictUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                      eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                           predictUrlProvider:nil
                                          deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                    v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                             inboxUrlProvider:self.mockInboxUrlProvider
                                    v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
        XCTFail(@"Expected Exception when predictUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: predictUrlProvider");
    }
}

- (void)testInit_deeplinkUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                      eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                           predictUrlProvider:self.mockPredictUrlProvider
                                          deeplinkUrlProvider:nil
                                    v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                             inboxUrlProvider:self.mockInboxUrlProvider
                                    v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
        XCTFail(@"Expected Exception when deeplinkUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: deeplinkUrlProvider");
    }
}

- (void)testInit_v2EventServiceUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                      eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                           predictUrlProvider:self.mockPredictUrlProvider
                                          deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                    v2EventServiceUrlProvider:nil
                                             inboxUrlProvider:self.mockInboxUrlProvider
                                    v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
        XCTFail(@"Expected Exception when v2EventServiceUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: v2EventServiceUrlProvider");
    }
}

- (void)testInit_inboxUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                      eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                           predictUrlProvider:self.mockPredictUrlProvider
                                          deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                    v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                             inboxUrlProvider:nil
                                    v3MessageInboxUrlProvider:self.mockV3MessageInboxUrlProvider];
        XCTFail(@"Expected Exception when inboxUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: inboxUrlProvider");
    }
}

- (void)testInit_v3MessageInboxUrlProvider_mustNotBeNil {
    @try {
        [[EMSEndpoint alloc] initWithClientServiceUrlProvider:self.mockClientServiceUrlProvider
                                      eventServiceUrlProvider:self.mockEventServiceUrlProvider
                                           predictUrlProvider:self.mockPredictUrlProvider
                                          deeplinkUrlProvider:self.mockDeeplinkUrlProvider
                                    v2EventServiceUrlProvider:self.mockV2EventServiceUrlProvider
                                             inboxUrlProvider:self.mockInboxUrlProvider
                                    v3MessageInboxUrlProvider:nil];
        XCTFail(@"Expected Exception when v3MessageInboxUrlProvider is nil!");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(exception.reason, @"Invalid parameter not satisfying: v3MessageInboxUrlProvider");
    }
}

- (void)testClientServiceUrl {
    NSString *result = [self.endpoint clientServiceUrl];

    XCTAssertEqualObjects(result, kClientServiceUrl);
}

- (void)testEventServiceUrl {
    NSString *result = [self.endpoint eventServiceUrl];

    XCTAssertEqualObjects(result, kEventServiceUrl);
}

- (void)testClientUrlWithApplicationCode {
    NSString *expectedUrl = [self clientBaseUrl];

    NSString *result = [self.endpoint clientUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testPushTokenUrlWithApplicationCode {
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/push-token",
                                                       [self clientBaseUrl]];

    NSString *result = [self.endpoint pushTokenUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testContactUrlWithApplicationCode {
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/contact",
                                                       [self clientBaseUrl]];

    NSString *result = [self.endpoint contactUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testContactTokenUrlWithApplicationCode {
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/contact-token",
                                                       [self clientBaseUrl]];

    NSString *result = [self.endpoint contactTokenUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testEventUrlWithApplicationCode_forV3 {
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/v3/apps/%@/client/events",
                                                       kEventServiceUrl,
                                                       kApplicationCode];

    NSString *result = [self.endpoint eventUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testEventUrlWithApplicationCode_forV4 {
    [MEExperimental enableFeature:EMSInnerFeature.eventServiceV4];

    NSString *expectedUrl = [NSString stringWithFormat:@"%@/v4/apps/%@/client/events",
                                                       kEventServiceUrl,
                                                       kApplicationCode];

    NSString *result = [self.endpoint eventUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testInlineInappUrlWithApplicationCode {
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/v3/apps/%@/inline-messages",
                                                       kEventServiceUrl,
                                                       kApplicationCode];

    NSString *result = [self.endpoint inlineInappUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testInlineInappUrlWithApplicationCode_forV4 {
    [MEExperimental enableFeature:EMSInnerFeature.eventServiceV4];
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/v4/apps/%@/inline-messages",
                                                       kEventServiceUrl,
                                                       kApplicationCode];

    NSString *result = [self.endpoint inlineInappUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testIsV3_shouldReturnYes_when_URLClientUrl {
    NSString *url = [self.endpoint clientUrlWithApplicationCode:@"testApplicationCode"];

    XCTAssertTrue([self.endpoint isMobileEngageUrl:url]);
}

- (void)testIsV3_shouldReturnNo_when_URLIsNotV3 {
    NSString *url = @"https://www.notv3url.com";

    XCTAssertFalse([self.endpoint isMobileEngageUrl:url]);
}

- (void)testIsV3_shouldReturnYes_when_URLEventUrl {
    NSString *url = [self.endpoint eventUrlWithApplicationCode:@"testApplicationCode"];

    XCTAssertTrue([self.endpoint isMobileEngageUrl:url]);
}

- (void)testIsV3_shouldReturnYes_when_URLInboxV3Url {
    NSString *url = [self.endpoint v3MessageInboxUrlApplicationCode:@"testApplicationCode"];

    XCTAssertTrue([self.endpoint isMobileEngageUrl:url]);
}

- (void)testIsV3_shouldReturnNo_when_URLInboxUrl {
    NSString *url = [self.endpoint inboxUrl];

    XCTAssertFalse([self.endpoint isMobileEngageUrl:url]);
}

- (void)testIsPush2InApp_shouldReturnYes_when_URLIisCorrect_andV4 {
    [MEExperimental enableFeature:EMSInnerFeature.eventServiceV4];
    NSString *url = [NSString stringWithFormat:@"%@/v4/apps/%@/messages/testMessageId",
                                               self.endpoint.eventServiceUrl,
                                               kApplicationCode];

    XCTAssertTrue([self.endpoint isPushToInAppUrl:url]);
}

- (void)testIsPush2InApp_shouldReturnNo_when_URLIisNotCorrect_andV4 {
    [MEExperimental enableFeature:EMSInnerFeature.eventServiceV4];
    NSString *url = [NSString stringWithFormat:@"%@/v4/apps/%@/inline-messages",
                                               self.endpoint.eventServiceUrl,
                                               kApplicationCode];

    XCTAssertFalse([self.endpoint isPushToInAppUrl:url]);
}

- (void)testIsPush2InApp_shouldReturnNo_when_URLIisNotEventService_andV4 {
    [MEExperimental enableFeature:EMSInnerFeature.eventServiceV4];
    NSString *url = [NSString stringWithFormat:@"%@/v4/apps/%@/messages/testMessageId",
                                               self.endpoint.clientServiceUrl,
                                               kApplicationCode];

    XCTAssertFalse([self.endpoint isPushToInAppUrl:url]);
}

- (void)testIsPush2InApp_shouldReturnYes_when_URLIisCorrect_andV3 {
    [MEExperimental disableFeature:EMSInnerFeature.eventServiceV4];
    NSString *url = [NSString stringWithFormat:@"%@/v3/apps/%@/messages/testMessageId",
                                               self.endpoint.clientServiceUrl,
                                               kApplicationCode];

    XCTAssertFalse([self.endpoint isPushToInAppUrl:url]);
}

- (void)testV3MessageInboxUrlWithApplicationCode {
    NSString *expectedUrl = [self v3MessageInboxUrl];

    NSString *result = [self.endpoint v3MessageInboxUrlApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testGeofenceUrlWithApplicationCode {
    NSString *expectedUrl = [NSString stringWithFormat:@"%@/v3/apps/%@/geo-fences",
                                                       kClientServiceUrl,
                                                       kApplicationCode];

    NSString *result = [self.endpoint geofenceUrlWithApplicationCode:kApplicationCode];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testPredictUrl {
    NSString *expectedUrl = @"https://recommender.scarabresearch.com";

    NSString *result = [self.endpoint predictUrl];

    XCTAssertEqualObjects(result, expectedUrl);
}

- (void)testDeeplinkUrl {
    NSString *result = [self.endpoint deeplinkUrl];

    XCTAssertEqualObjects(result, kDeeplinkUrl);
}

- (void)testV2EventServiceUrl {
    NSString *result = [self.endpoint v2EventServiceUrl];

    XCTAssertEqualObjects(result, kV2ServiceUrl);
}

- (void)testInboxUrl {
    NSString *result = [self.endpoint inboxUrl];

    XCTAssertEqualObjects(result, kInboxUrl);
}

- (void)testRemoteConfigUrl {
    NSString *expected = [NSString stringWithFormat:[NSString stringWithFormat:@"https://mobile-sdk-config.gservice.emarsys.net/%@",
                                                                               kApplicationCode]];

    NSString *result = [self.endpoint remoteConfigUrl:kApplicationCode];

    XCTAssertEqualObjects(result, expected);
}

- (void)testRemoteConfigSignatureUrl {
    NSString *expected = [NSString stringWithFormat:[NSString stringWithFormat:@"https://mobile-sdk-config.gservice.emarsys.net/signature/%@",
                                                                               kApplicationCode]];

    NSString *result = [self.endpoint remoteConfigSignatureUrl:kApplicationCode];

    XCTAssertEqualObjects(result, expected);
}

- (void)testUpdateUrlsWithRemoteConfig {
    NSString *const eventServiceUrl = @"newEventServiceUrl";
    NSString *const clientServiceUrl = @"newClientServiceUrl";
    NSString *const predictServiceUrl = @"newPredictServiceUrl";
    NSString *const v2ServiceUrl = @"newV2ServiceUrl";
    NSString *const deeplinkServiceUrl = @"newDeeplinkServiceUrl";
    NSString *const inboxServiceUrl = @"newInboxServiceUrl";
    NSString *const v3MessageInboxServiceUrl = @"newV3MessageInboxServiceUrl";
    EMSRemoteConfig *remoteConfig = [[EMSRemoteConfig alloc] initWithEventService:eventServiceUrl
                                                                    clientService:clientServiceUrl
                                                                   predictService:predictServiceUrl
                                                            mobileEngageV2Service:v2ServiceUrl
                                                                  deepLinkService:deeplinkServiceUrl
                                                                     inboxService:inboxServiceUrl
                                                            v3MessageInboxService:v3MessageInboxServiceUrl
                                                                         logLevel:nil
                                                                         features:nil];

    [self.endpoint updateUrlsWithRemoteConfig:remoteConfig];

    OCMVerify([self.mockEventServiceUrlProvider updateValue:eventServiceUrl]);
    OCMVerify([self.mockClientServiceUrlProvider updateValue:clientServiceUrl]);
    OCMVerify([self.mockPredictUrlProvider updateValue:predictServiceUrl]);
    OCMVerify([self.mockV2EventServiceUrlProvider updateValue:v2ServiceUrl]);
    OCMVerify([self.mockDeeplinkUrlProvider updateValue:deeplinkServiceUrl]);
    OCMVerify([self.mockInboxUrlProvider updateValue:inboxServiceUrl]);
    OCMVerify([self.mockV3MessageInboxUrlProvider updateValue:v3MessageInboxServiceUrl]);
}

- (void)testReset {
    [self.endpoint reset];

    OCMVerify([self.mockInboxUrlProvider updateValue:nil]);
    OCMVerify([self.mockV2EventServiceUrlProvider updateValue:nil]);
    OCMVerify([self.mockDeeplinkUrlProvider updateValue:nil]);
    OCMVerify([self.mockPredictUrlProvider updateValue:nil]);
    OCMVerify([self.mockClientServiceUrlProvider updateValue:nil]);
    OCMVerify([self.mockEventServiceUrlProvider updateValue:nil]);
    OCMVerify([self.mockV3MessageInboxUrlProvider updateValue:nil]);
}

- (NSString *)clientBaseUrl {
    return [NSString stringWithFormat:@"%@/v3/apps/%@/client",
                                      kClientServiceUrl,
                                      kApplicationCode];
}

- (NSString *)v3MessageInboxUrl {
    return [NSString stringWithFormat:@"%@/v3/apps/%@/inbox",
                                      kV3MessageInboxServiceUrl,
                                      kApplicationCode];
}

@end
