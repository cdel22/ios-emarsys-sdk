#import "Kiwi.h"
#import "EMSConfigBuilder.h"
#import "EMSConfig.h"
#import "MobileEngage.h"
#import "MobileEngage+Test.h"
#import "MobileEngage+Private.h"
#import "MobileEngageInternal+Private.h"
#import "MEInApp+Private.h"
#import "MEExperimental+Test.h"
#import "MEInbox.h"
#import "MEInboxV2.h"
#import "MEInbox+Private.h"


static NSString *const kAppId = @"kAppId";

SPEC_BEGIN(MobileEngageTests)

        beforeEach(^{
           [MEExperimental reset];
        });

        id (^mobileEngageInternal)(void) = ^id() {
            id mobileEngageInternalMock = [MobileEngageInternal mock];

            [[mobileEngageInternalMock should] receive:@selector(setupWithConfig:launchOptions:requestRepositoryFactory:shardRepository:logRepository:requestContext:)];
            [[mobileEngageInternalMock should] receive:@selector(setNotificationCenterManager:) withArguments:kw_any()];

            NSString *applicationCode = kAppId;
            NSString *applicationPassword = @"appSecret";

            EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                [builder setMobileEngageApplicationCode:applicationCode
                                    applicationPassword:applicationPassword];
                [builder setMerchantId:@"dummyMerchantId"];
                [builder setContactFieldId:@3];
            }];

            [MobileEngage setupWithMobileEngageInternal:mobileEngageInternalMock
                                                 config:config
                                          launchOptions:[NSDictionary new]];
            return mobileEngageInternalMock;
        };

        describe(@"setupWithConfig:launchOptions:inApp:requestRepositoryFactory:", ^{
            it(@"should call internal implementation's method", ^{
                mobileEngageInternal();
            });

            it(@"should create inbox instance", ^{
                mobileEngageInternal();
                [[theValue(MobileEngage.inbox) shouldNot] beNil];
            });

            it(@"should create one inbox instance", ^{
                mobileEngageInternal();
                id<MEInboxProtocol> inbox1 = MobileEngage.inbox;
                id<MEInboxProtocol> inbox2 = MobileEngage.inbox;

                [[(NSObject *)inbox1 should] equal:inbox2];
            });

            it(@"should create inApp instance", ^{
                mobileEngageInternal();

                [[MobileEngage.inApp shouldNot] beNil];
            });

            it(@"should create MENotificationCenterManager instance", ^{
                id mobileEngageInternalMock = [MobileEngageInternal mock];
                [[mobileEngageInternalMock should] receive:@selector(setupWithConfig:launchOptions:requestRepositoryFactory:shardRepository:logRepository:requestContext:)];
                [[mobileEngageInternalMock should] receive:@selector(setNotificationCenterManager:) withArguments:kw_any()];
                KWCaptureSpy *spy = [mobileEngageInternalMock captureArgument:@selector(setNotificationCenterManager:) atIndex:0];

                NSString *applicationCode = kAppId;
                NSString *applicationPassword = @"appSecret";

                EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                    [builder setMobileEngageApplicationCode:applicationCode
                                        applicationPassword:applicationPassword];
                    [builder setMerchantId:@"dummyMerchantId"];
                    [builder setContactFieldId:@3];
                }];

                [MobileEngage setupWithMobileEngageInternal:mobileEngageInternalMock
                                                     config:config
                                              launchOptions:[NSDictionary new]];

                [[spy.argument shouldNot] beNil];
            });

            it(@"should assign tracker to MEInApp", ^{
                mobileEngageInternal();
                [[(NSObject *) MobileEngage.inApp.inAppTracker shouldNot] beNil];
            });

            it(@"should call internal's setup with non-null logRepository", ^{
                id mobileEngageInternalMock = [MobileEngageInternal nullMock];
                [[mobileEngageInternalMock should] receive:@selector(setupWithConfig:launchOptions:requestRepositoryFactory:shardRepository:logRepository:requestContext:)];
                KWCaptureSpy *spy = [mobileEngageInternalMock captureArgument:@selector(setupWithConfig:launchOptions:requestRepositoryFactory:shardRepository:logRepository:requestContext:) atIndex:4];

                NSString *applicationCode = kAppId;
                NSString *applicationPassword = @"appSecret";

                EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                    [builder setMobileEngageApplicationCode:applicationCode
                                        applicationPassword:applicationPassword];
                    [builder setMerchantId:@"dummyMerchantId"];
                    [builder setContactFieldId:@3];
                }];

                [MobileEngage setupWithMobileEngageInternal:mobileEngageInternalMock
                                                     config:config
                                              launchOptions:[NSDictionary new]];

                [[spy.argument shouldNot] beNil];
            });

            it(@"should set logRepository on MEInApp instance", ^{
                id mobileEngageInternalMock = [MobileEngageInternal nullMock];
                [[mobileEngageInternalMock should] receive:@selector(setupWithConfig:launchOptions:requestRepositoryFactory:shardRepository:logRepository:requestContext:)];
                KWCaptureSpy *spy = [mobileEngageInternalMock captureArgument:@selector(setupWithConfig:launchOptions:requestRepositoryFactory:shardRepository:logRepository:requestContext:) atIndex:4];

                NSString *applicationCode = kAppId;
                NSString *applicationPassword = @"appSecret";

                EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                    [builder setMobileEngageApplicationCode:applicationCode
                                        applicationPassword:applicationPassword];
                    [builder setMerchantId:@"dummyMerchantId"];
                    [builder setContactFieldId:@3];
                }];

                [MobileEngage setupWithMobileEngageInternal:mobileEngageInternalMock
                                                     config:config
                                              launchOptions:[NSDictionary new]];

                [[MobileEngage.inApp.logRepository should] equal:spy.argument];
            });

            it(@"should set timestampProvider on MEInApp instance", ^{
                NSString *applicationCode = kAppId;
                NSString *applicationPassword = @"appSecret";

                EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                    [builder setMobileEngageApplicationCode:applicationCode
                                        applicationPassword:applicationPassword];
                    [builder setMerchantId:@"dummyMerchantId"];
                    [builder setContactFieldId:@3];
                }];

                [MobileEngage setupWithMobileEngageInternal:[MobileEngageInternal nullMock]
                                                     config:config
                                              launchOptions:[NSDictionary new]];

                [[MobileEngage.inApp.timestampProvider shouldNot] beNil];
            });
        });

        describe(@"trackDeepLinkWithUserActivity:sourceHandler:", ^{
            it(@"should call internal implementation's method", ^{
                NSUserActivity *userActivity = [NSUserActivity mock];
                MESourceHandler sourceHandler = ^(NSString *source) {
                };
                [[mobileEngageInternal() should] receive:@selector(trackDeepLinkWith:sourceHandler:)
                                           withArguments:userActivity, sourceHandler];

                [MobileEngage trackDeepLinkWith:userActivity
                                  sourceHandler:sourceHandler];
            });
        });

        describe(@"setPushToken:", ^{
            it(@"should call internal implementation's method", ^{
                NSData *deviceToken = [NSData new];
                [[mobileEngageInternal() should] receive:@selector(setPushToken:) withArguments:deviceToken];

                [MobileEngage setPushToken:deviceToken];
            });
        });

        describe(@"anonymous appLogin", ^{
            it(@"should call internal implementation's method", ^{
                [[mobileEngageInternal() should] receive:@selector(appLogin)];

                [MobileEngage appLogin];
            });
        });

        describe(@"appLoginWithContactFieldId:contactFieldValue:", ^{
            it(@"should call internal implementation's method", ^{
                [[mobileEngageInternal() should] receive:@selector(appLoginWithContactFieldId:contactFieldValue:)];

                [MobileEngage appLoginWithContactFieldId:@3
                                       contactFieldValue:@"test@test.com"];
            });

            it(@"should set the contactFieldId and contactFieldValue in inbox", ^{
                NSString *applicationCode = kAppId;
                NSString *applicationPassword = @"appSecret";

                EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                    [builder setMobileEngageApplicationCode:applicationCode
                                        applicationPassword:applicationPassword];
                    [builder setMerchantId:@"dummyMerchantId"];
                    [builder setContactFieldId:@3];
                }];
                [MobileEngage setupWithConfig:config
                                launchOptions:[NSDictionary new]];
                [MobileEngage appLoginWithContactFieldId:@5
                                       contactFieldValue:@"three"];

                [[((MEInbox*)MobileEngage.inbox).requestContext.appLoginParameters.contactFieldId should] equal:@5];
                [[((MEInbox*)MobileEngage.inbox).requestContext.appLoginParameters.contactFieldValue should] equal:@"three"];
            });
        });

        describe(@"appLogout", ^{
            it(@"should call internal implementation's method", ^{
                [[mobileEngageInternal() should] receive:@selector(appLogout)];

                [MobileEngage appLogout];
            });
        });

        describe(@"trackMessageOpenWithUserInfo:", ^{
            it(@"should call internal implementation's method", ^{
                [[mobileEngageInternal() should] receive:@selector(trackMessageOpenWithUserInfo:)];

                [MobileEngage trackMessageOpenWithUserInfo:@{}];
            });
        });

        describe(@"trackMessageOpenWithInboxMessage:", ^{
            it(@"should call internal implementation's method", ^{
                [[mobileEngageInternal() should] receive:@selector(trackMessageOpenWithInboxMessage:)];
                EMSNotification *message = [EMSNotification new];
                message.id = @"testID";
                [MobileEngage trackMessageOpenWithInboxMessage:message];
            });
        });

        describe(@"trackCustomEvent:eventAttributes:", ^{
            it(@"should call internal implementation's method", ^{
                [[mobileEngageInternal() should] receive:@selector(trackCustomEvent:eventAttributes:)];

                [MobileEngage trackCustomEvent:@"eventName"
                               eventAttributes:@{}];
            });
        });

        describe(@"experimentalFeatures", ^{
            context(@"Inbox", ^{
                it(@"should use inbox v1 when USER_CENTRIC_INBOX flipper is turned off", ^{
                    NSString *applicationCode = kAppId;
                    NSString *applicationPassword = @"appSecret";

                    EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                        [builder setMobileEngageApplicationCode:applicationCode
                                            applicationPassword:applicationPassword];
                        [builder setMerchantId:@"dummyMerchantId"];
                        [builder setContactFieldId:@3];
                    }];
                    [MobileEngage setupWithConfig:config
                                    launchOptions:[NSDictionary new]];

                    [[theValue([MobileEngage.inbox isKindOfClass:[MEInbox class]]) should] beYes];
                });

                it(@"should use inbox V2 when USER_CENTRIC_INBOX flipper is turned on", ^{
                    NSString *applicationCode = kAppId;
                    NSString *applicationPassword = @"appSecret";

                    EMSConfig *config = [EMSConfig makeWithBuilder:^(EMSConfigBuilder *builder) {
                        [builder setMobileEngageApplicationCode:applicationCode
                                            applicationPassword:applicationPassword];
                        [builder setExperimentalFeatures:@[USER_CENTRIC_INBOX]];
                        [builder setMerchantId:@"dummyMerchantId"];
                        [builder setContactFieldId:@3];
                    }];
                    [MobileEngage setupWithConfig:config
                                    launchOptions:[NSDictionary new]];

                    [[theValue([MobileEngage.inbox isKindOfClass:[MEInboxV2 class]]) should] beYes];
                });
            });
        });

SPEC_END
