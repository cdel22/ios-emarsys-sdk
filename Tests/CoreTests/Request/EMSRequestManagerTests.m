//
//  Copyright (c) 2017 Emarsys. All rights reserved.
//

#import "Kiwi.h"
#import "EMSRequestManager.h"
#import "EMSSQLiteHelper.h"
#import "EMSSqliteSchemaHandler.h"
#import "EMSSchemaContract.h"
#import "EMSRequestModelRepository.h"
#import "EMSShardRepository.h"
#import "EMSShard.h"
#import "FakeLogRepository.h"
#import "EMSReachability.h"
#import "EMSTimestampProvider.h"
#import "EMSUUIDProvider.h"
#import "EMSWaiter.h"
#import "NSError+EMSCore.h"
#import "EMSDefaultWorker.h"
#import "EMSResponseModel.h"

#define TEST_DB_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"TestDB.db"]

SPEC_BEGIN(EMSRequestManagerTests)
        __block EMSSQLiteHelper *helper;
        __block EMSRequestModelRepository *requestModelRepository;

        EMSRequestManager *(^createRequestManager)(CoreSuccessBlock successBlock, CoreErrorBlock errorBlock, EMSRequestModelRepository *requestRepository, EMSShardRepository *shardRepository, id <EMSLogRepositoryProtocol> logRepository) = ^EMSRequestManager *(CoreSuccessBlock successBlock, CoreErrorBlock errorBlock, EMSRequestModelRepository *requestRepository, EMSShardRepository *shardRepository, id <EMSLogRepositoryProtocol> logRepository) {
            NSOperationQueue *queue = [NSOperationQueue new];
            queue.maxConcurrentOperationCount = 1;
            queue.qualityOfService = NSQualityOfServiceUtility;

            EMSCompletionMiddleware *middleware = [[EMSCompletionMiddleware alloc] initWithSuccessBlock:successBlock
                                                                                             errorBlock:errorBlock];
            EMSRESTClient *restClient = [EMSRESTClient clientWithSuccessBlock:middleware.successBlock
                                                                   errorBlock:middleware.errorBlock
                                                                logRepository:logRepository];
            EMSDefaultWorker *worker = [[EMSDefaultWorker alloc] initWithOperationQueue:queue
                                                                      requestRepository:requestRepository
                                                                     connectionWatchdog:[[EMSConnectionWatchdog alloc] initWithOperationQueue:queue]
                                                                             restClient:restClient
                                                                             errorBlock:errorBlock];
            return [[EMSRequestManager alloc] initWithCoreQueue:queue
                                           completionMiddleware:middleware
                                                     restClient:restClient
                                                         worker:worker
                                              requestRepository:requestRepository
                                                shardRepository:shardRepository];
        };

        describe(@"initWithCoreQueue:completionMiddleware:restClient:worker:requestRepository:shardRepository:", ^{

            it(@"should throw an exception when coreQueue is nil", ^{
                @try {
                    [[EMSRequestManager alloc] initWithCoreQueue:nil
                                            completionMiddleware:[EMSCompletionMiddleware mock]
                                                      restClient:[EMSRESTClient mock]
                                                          worker:[EMSDefaultWorker mock]
                                               requestRepository:[EMSRequestModelRepository mock]
                                                 shardRepository:[EMSShardRepository mock]];
                    fail(@"Expected Exception when coreQueue is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: coreQueue"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw an exception when completionMiddleware is nil", ^{
                @try {
                    [[EMSRequestManager alloc] initWithCoreQueue:[NSOperationQueue mock]
                                            completionMiddleware:nil
                                                      restClient:[EMSRESTClient mock]
                                                          worker:[EMSDefaultWorker mock]
                                               requestRepository:[EMSRequestModelRepository mock]
                                                 shardRepository:[EMSShardRepository mock]];
                    fail(@"Expected Exception when completionMiddleware is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: completionMiddleware"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw an exception when restClient is nil", ^{
                @try {
                    [[EMSRequestManager alloc] initWithCoreQueue:[NSOperationQueue mock]
                                            completionMiddleware:[EMSCompletionMiddleware mock]
                                                      restClient:nil
                                                          worker:[EMSDefaultWorker mock]
                                               requestRepository:[EMSRequestModelRepository mock]
                                                 shardRepository:[EMSShardRepository mock]];
                    fail(@"Expected Exception when restClient is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: restClient"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw an exception when worker is nil", ^{
                @try {
                    [[EMSRequestManager alloc] initWithCoreQueue:[NSOperationQueue mock]
                                            completionMiddleware:[EMSCompletionMiddleware mock]
                                                      restClient:[EMSRESTClient mock]
                                                          worker:nil
                                               requestRepository:[EMSRequestModelRepository mock]
                                                 shardRepository:[EMSShardRepository mock]];
                    fail(@"Expected Exception when worker is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: worker"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw an exception when requestRepository is nil", ^{
                @try {
                    [[EMSRequestManager alloc] initWithCoreQueue:[NSOperationQueue mock]
                                            completionMiddleware:[EMSCompletionMiddleware mock]
                                                      restClient:[EMSRESTClient mock]
                                                          worker:[EMSDefaultWorker mock]
                                               requestRepository:nil
                                                 shardRepository:[EMSShardRepository mock]];
                    fail(@"Expected Exception when requestRepository is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: requestRepository"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw an exception when shardRepository is nil", ^{
                @try {
                    [[EMSRequestManager alloc] initWithCoreQueue:[NSOperationQueue mock]
                                            completionMiddleware:[EMSCompletionMiddleware mock]
                                                      restClient:[EMSRESTClient mock]
                                                          worker:[EMSDefaultWorker mock]
                                               requestRepository:[EMSRequestModelRepository mock]
                                                 shardRepository:nil];
                    fail(@"Expected Exception when shardRepository is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: shardRepository"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });
        });

        describe(@"EMSRequestManager", ^{
            __block EMSRequestManager *requestManager;
            __block EMSShardRepository *shardRepository;

            beforeEach(^{
                EMSSQLiteHelper *helper = [[EMSSQLiteHelper alloc] initWithDatabasePath:TEST_DB_PATH
                                                                         schemaDelegate:[EMSSqliteSchemaHandler new]];
                [helper open];
                [helper executeCommand:SQL_REQUEST_PURGE];
                requestModelRepository = [[EMSRequestModelRepository alloc] initWithDbHelper:helper];

                shardRepository = [EMSShardRepository mock];
                CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {

                };
                CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {

                };
                requestManager = createRequestManager(successBlock, errorBlock, [[EMSRequestModelRepository alloc] initWithDbHelper:helper], shardRepository, nil);
            });

            afterEach(^{
                [[NSFileManager defaultManager] removeItemAtPath:TEST_DB_PATH
                                                           error:nil];
            });

            it(@"should do networking with the gained EMSRequestModel and return success", ^{
                NSString *url = @"https://www.google.com";

                EMSRequestModel *model = [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
                        [builder setUrl:url];
                        [builder setMethod:HTTPMethodGET];
                    }
                                                        timestampProvider:[EMSTimestampProvider new]
                                                             uuidProvider:[EMSUUIDProvider new]];

                __block NSString *checkableRequestId;

                CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {
                    checkableRequestId = requestId;
                };
                CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                    NSLog(@"ERROR: %@", error);
                    fail([NSString stringWithFormat:@"errorBlock: %@",
                                                    error]);
                };
                EMSRequestManager *core = createRequestManager(successBlock, errorBlock, requestModelRepository, [EMSShardRepository new], nil);

                [core submitRequestModel:model
                     withCompletionBlock:nil];

                [[checkableRequestId shouldEventually] equal:model.requestId];
            });

            it(@"should do networking with the gained EMSRequestModel and return success in completion block", ^{
                NSString *url = @"https://www.google.com";

                EMSRequestModel *model = [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
                        [builder setUrl:url];
                        [builder setMethod:HTTPMethodGET];
                    }
                                                        timestampProvider:[EMSTimestampProvider new]
                                                             uuidProvider:[EMSUUIDProvider new]];

                CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {

                };
                CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                    NSLog(@"ERROR: %@", error);
                    fail([NSString stringWithFormat:@"errorBlock: %@",
                                                    error]);
                };
                EMSRequestManager *core = createRequestManager(successBlock, errorBlock, requestModelRepository, [EMSShardRepository new], nil);

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                __block NSError *returnedError = [NSError errorWithCode:500
                                                   localizedDescription:@"completion block not called!"];
                [core submitRequestModel:model
                     withCompletionBlock:^(NSError *error) {
                         returnedError = error;
                         [exp fulfill];
                     }];

                [EMSWaiter waitForExpectations:@[exp]
                                       timeout:30];
                [[returnedError should] beNil];
            });

            it(@"should do networking with the gained EMSRequestModel and return failure", ^{
                NSString *url = @"https://alma.korte.szilva/egyeb/palinkagyumolcsok";

                EMSRequestModel *model = [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
                        [builder setUrl:url];
                        [builder setMethod:HTTPMethodGET];
                    }
                                                        timestampProvider:[EMSTimestampProvider new]
                                                             uuidProvider:[EMSUUIDProvider new]];

                __block NSString *checkableRequestId;
                __block NSError *checkableError;

                CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {
                    fail([NSString stringWithFormat:@"SuccessBlock: %@", response]);
                };
                CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                    checkableRequestId = requestId;
                    checkableError = error;
                };
                EMSRequestManager *core = createRequestManager(successBlock, errorBlock, requestModelRepository, [EMSShardRepository new], nil);

                [core submitRequestModel:model withCompletionBlock:nil];

                [[checkableRequestId shouldEventually] equal:model.requestId];
                [[checkableError shouldNotEventually] beNil];
            });

            it(@"should do networking with the gained EMSRequestModel and return success in completion block", ^{
                NSString *url = @"https://alma.korte.szilva/egyeb/palinkagyumolcsok";

                EMSRequestModel *model = [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
                        [builder setUrl:url];
                        [builder setMethod:HTTPMethodGET];
                    }
                                                        timestampProvider:[EMSTimestampProvider new]
                                                             uuidProvider:[EMSUUIDProvider new]];

                CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {
                    fail([NSString stringWithFormat:@"SuccessBlock: %@", response]);
                };
                CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                };
                EMSRequestManager *core = createRequestManager(successBlock, errorBlock, requestModelRepository, [EMSShardRepository new], nil);

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                __block NSError *returnedError = nil;
                [core submitRequestModel:model withCompletionBlock:^(NSError *error) {
                    returnedError = error;
                    [exp fulfill];
                }];

                [EMSWaiter waitForExpectations:@[exp] timeout:30];
                [[returnedError shouldNot] beNil];
            });

            it(@"should throw an exception, when requestModel is nil", ^{
                @try {
                    [requestManager submitRequestModel:nil withCompletionBlock:nil];
                    fail(@"Expected exception when requestModel is nil");
                } @catch (NSException *exception) {
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw an exception, when shardModel is nil", ^{
                @try {
                    [requestManager submitShard:nil];
                    fail(@"Expected exception when shardModel is nil");
                } @catch (NSException *exception) {
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should save shard via shardRepository", ^{
                EMSShard *shard = [EMSShard mock];

                [[shardRepository shouldEventually] receive:@selector(add:) withArguments:shard];

                [requestManager submitShard:shard];
            });

            context(@"submitRequestModelNow:withCompletionBlock:", ^{

                it(@"should throw exception, when requestModel is nil", ^{
                    @try {
                        [requestManager submitRequestModelNow:nil
                                          withCompletionBlock:^(NSError *error) {
                                          }];
                        fail(@"Expected exception when requestModel is nil");
                    } @catch (NSException *exception) {
                        [[theValue(exception) shouldNot] beNil];
                    }
                });

                it(@"should invoke restClient with the given requestModel and middleware successBlock and errorBlock", ^{
                    EMSRequestModel *requestModel = [EMSRequestModel nullMock];

                    NSOperationQueue *queue = [NSOperationQueue new];
                    queue.maxConcurrentOperationCount = 1;
                    queue.qualityOfService = NSQualityOfServiceUtility;

                    CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {
                    };
                    CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                    };

                    EMSRequestModelRepository *requestRepository = [EMSRequestModelRepository mock];

                    EMSCompletionMiddleware *middleware = [EMSCompletionMiddleware nullMock];
                    [middleware stub:@selector(successBlock) andReturn:successBlock];
                    [middleware stub:@selector(errorBlock) andReturn:errorBlock];

                    EMSRESTClient *restClient = [EMSRESTClient nullMock];
                    [[restClient should] receive:@selector(executeTaskWithRequestModel:successBlock:errorBlock:)
                                   withArguments:requestModel, successBlock, errorBlock];

                    EMSDefaultWorker *worker = [EMSDefaultWorker nullMock];
                    EMSRequestManager *core = [[EMSRequestManager alloc] initWithCoreQueue:queue
                                                                      completionMiddleware:middleware
                                                                                restClient:restClient
                                                                                    worker:worker
                                                                         requestRepository:requestRepository
                                                                           shardRepository:shardRepository];

                    [core submitRequestModelNow:requestModel
                            withCompletionBlock:^(NSError *error) {

                            }];
                });

                it(@"should invoke completionBlock on mainThread", ^{
                    EMSRequestModel *requestModel = [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
                            [builder setUrl:@"https://ems-denna.herokuapp.com/echo"];
                            [builder setMethod:HTTPMethodGET];
                        }
                                                                   timestampProvider:[EMSTimestampProvider new]
                                                                        uuidProvider:[EMSUUIDProvider new]];

                    NSOperationQueue *queue = [NSOperationQueue new];
                    queue.maxConcurrentOperationCount = 1;
                    queue.qualityOfService = NSQualityOfServiceUtility;

                    CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {
                    };
                    CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                    };

                    EMSRequestModelRepository *requestRepository = [EMSRequestModelRepository mock];

                    EMSCompletionMiddleware *middleware = [[EMSCompletionMiddleware alloc] initWithSuccessBlock:successBlock
                                                                                                     errorBlock:errorBlock];

                    EMSRESTClient *restClient = [EMSRESTClient nullMock];
                    [[restClient should] receive:@selector(executeTaskWithRequestModel:successBlock:errorBlock:)
                                   withArguments:requestModel,
                                                 middleware.successBlock,
                                                 middleware.errorBlock];

                    EMSDefaultWorker *worker = [[EMSDefaultWorker alloc] initWithOperationQueue:queue
                                                                              requestRepository:requestRepository
                                                                             connectionWatchdog:[[EMSConnectionWatchdog alloc] initWithOperationQueue:queue]
                                                                                     restClient:restClient
                                                                                     errorBlock:errorBlock];
                    EMSRequestManager *core = [[EMSRequestManager alloc] initWithCoreQueue:queue
                                                                      completionMiddleware:middleware
                                                                                restClient:restClient
                                                                                    worker:worker
                                                                         requestRepository:requestRepository
                                                                           shardRepository:shardRepository];

                    __block BOOL onMainThread = NO;
                    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                    [core submitRequestModelNow:requestModel
                            withCompletionBlock:^(NSError *error) {
                                onMainThread = [[NSThread currentThread] isMainThread];
                                [expectation fulfill];
                            }];

                    middleware.successBlock(requestModel.requestId, [EMSResponseModel nullMock]);
                    [EMSWaiter waitForExpectations:@[expectation]
                                           timeout:2];
                    [[theValue(onMainThread) should] beYes];
                });
            });

        });

        describe(@"Core", ^{
            it(@"should not crash when EMSRequestManager created on Thread A and Reachability is Offline and there are lot of request in the queue and Reachability goes offline and still a lot of requests triggering", ^{

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForExpectation"];
                __block NSInteger successCount = 0;
                __block NSInteger errorCount = 0;


                EMSSQLiteHelper *dbHelper = [[EMSSQLiteHelper alloc] initWithDatabasePath:TEST_DB_PATH
                                                                           schemaDelegate:[EMSSqliteSchemaHandler new]];
                EMSRequestModelRepository *repository = [[EMSRequestModelRepository alloc] initWithDbHelper:dbHelper];

                CoreSuccessBlock successBlock = ^(NSString *requestId, EMSResponseModel *response) {
                    successCount++;
                    if (successCount + errorCount >= 100) {
                        [exp fulfill];
                    }

                    if (successCount == 30) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            EMSReachability *reachabilityOfflineMock = [EMSReachability nullMock];
                            [[reachabilityOfflineMock should] receive:@selector(currentReachabilityStatus)
                                                            andReturn:theValue(NotReachable)
                                                     withCountAtLeast:0];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kEMSReachabilityChangedNotification
                                                                                object:reachabilityOfflineMock];
                        });
                    }

                    if (successCount == 70) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            EMSReachability *reachabilityOnlineMock = [EMSReachability nullMock];
                            [[reachabilityOnlineMock should] receive:@selector(currentReachabilityStatus)
                                                           andReturn:theValue(ReachableViaWiFi)
                                                    withCountAtLeast:0];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kEMSReachabilityChangedNotification
                                                                                object:reachabilityOnlineMock];
                        });
                    }

                };
                CoreErrorBlock errorBlock = ^(NSString *requestId, NSError *error) {
                    errorCount++;
                    if (successCount + errorCount >= 100) {
                        [exp fulfill];
                    }
                };
                EMSRequestManager *requestManager = createRequestManager(successBlock, errorBlock, repository, [EMSShardRepository new], [FakeLogRepository new]);

                for (int i = 0; i < 100; ++i) {
                    EMSRequestModel *model = [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
                            [builder setUrl:@"https://ems-denna.herokuapp.com/echo"];
                            [builder setMethod:HTTPMethodGET];
                        }
                                                            timestampProvider:[EMSTimestampProvider new]
                                                                 uuidProvider:[EMSUUIDProvider new]];
                    [requestManager submitRequestModel:model withCompletionBlock:nil];
                }

                EMSReachability *reachabilityOnlineMock = [EMSReachability nullMock];
                [[reachabilityOnlineMock should] receive:@selector(currentReachabilityStatus)
                                               andReturn:theValue(ReachableViaWiFi)
                                        withCountAtLeast:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:kEMSReachabilityChangedNotification
                                                                    object:reachabilityOnlineMock];

                [EMSWaiter waitForExpectations:@[exp] timeout:60];
                [[theValue(successCount) should] equal:theValue(100)];
                [[theValue(errorCount) should] equal:theValue(0)];
            });
        });

SPEC_END
