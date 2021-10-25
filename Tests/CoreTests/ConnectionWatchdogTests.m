//
//  Copyright (c) 2017 Emarsys. All rights reserved.
//

#import "Kiwi.h"
#import "EMSConnectionWatchdog.h"
#import "FakeConnectionChangeListener.h"
#import "EMSWaiter.h"
#import "XCTestCase+Helper.h"

@interface EMSConnectionWatchdog(Tests)

- (id)notificationToken;

@end

SPEC_BEGIN(EMSConnectionWatchdogTest)

    __block NSOperationQueue *queue;
    
    beforeEach(^{
        queue = [self createTestOperationQueue];
    });

    afterEach(^{
        [self tearDownOperationQueue:queue];
    });

        void (^waitForOperationQueue)() = ^void() {
            XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"waitForOperationQueue"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [expectation fulfill];
            }];
            XCTWaiterResult waiterResult = [XCTWaiter waitForExpectations:@[expectation]
                                                                  timeout:10];
            XCTAssertEqual(waiterResult, XCTWaiterResultCompleted);
        };

        describe(@"init", ^{
            it(@"should throw exception when publicApiOperationQueue is nil", ^{
                @try {
                    [[EMSConnectionWatchdog alloc] initWithReachability:[EMSReachability mock]
                                                         operationQueue:nil];
                    fail(@"Expected exception when publicApiOperationQueue is nil");
                } @catch (NSException *exception) {
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw exception when reachability is nil", ^{
                @try {
                    [[EMSConnectionWatchdog alloc] initWithReachability:nil
                                                         operationQueue:[NSOperationQueue mock]];
                    fail(@"Expected exception when reachability is nil");
                } @catch (NSException *exception) {
                    [[theValue(exception) shouldNot] beNil];
                }
            });
        });

        describe(@"connectionState", ^{

            it(@"should be NotReachable when it's really not reachable", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(NotReachable)];

                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:[NSOperationQueue currentQueue]];
                [[@([watchdog connectionState]) should] equal:@(NotReachable)];
            });

            it(@"should be ReachableViaWiFi when it's ReachableViaWiFi", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(ReachableViaWiFi)];

                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:[NSOperationQueue currentQueue]];
                [[@([watchdog connectionState]) should] equal:@(ReachableViaWiFi)];
            });

            it(@"should be ReachableViaWWAN when it's ReachableViaWWAN", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(ReachableViaWWAN)];

                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:[NSOperationQueue currentQueue]];
                [[@([watchdog connectionState]) should] equal:@(ReachableViaWWAN)];
            });

        });

        describe(@"isConnected", ^{

            it(@"should be NO when it's not reachable", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(NotReachable)];

                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:[NSOperationQueue currentQueue]];
                [[@([watchdog isConnected]) should] beNo];
            });

            it(@"should be YES when it's ReachableViaWiFi", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(ReachableViaWiFi)];

                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:[NSOperationQueue currentQueue]];
                [[@([watchdog isConnected]) should] beYes];
            });

            it(@"should be YES when it's ReachableViaWWAN", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(ReachableViaWWAN)];

                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:[NSOperationQueue currentQueue]];
                [[@([watchdog isConnected]) should] beYes];
            });

        });

        describe(@"connectionChangeListener", ^{

            it(@"should be called when connection status changes", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(startNotifier)
                                         andReturn:@YES];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(ReachableViaWiFi)
                                  withCountAtLeast:1];
                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:queue];
                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForExpectation"];

                FakeConnectionChangeListener *listener = [[FakeConnectionChangeListener alloc] initWithCompletionBlock:^(NSOperationQueue *currentQueue) {
                    [exp fulfill];
                }];
                watchdog.connectionChangeListener = listener;

                waitForOperationQueue();

                [[NSNotificationCenter defaultCenter] postNotificationName:kEMSReachabilityChangedNotification
                                                                    object:reachabilityMock];

                [EMSWaiter waitForExpectations:@[exp]
                                       timeout:10];

                [[theValue(listener.networkStatus) should] equal:theValue(ReachableViaWiFi)];
                [[theValue(listener.connected) should] equal:theValue(YES)];

                [[NSNotificationCenter defaultCenter] removeObserver:watchdog.notificationToken];
            });

            it(@"should be called on the set publicApiOperationQueue", ^{
                EMSReachability *reachabilityMock = [EMSReachability mock];
                [[reachabilityMock should] receive:@selector(startNotifier)
                                         andReturn:@YES];
                [[reachabilityMock should] receive:@selector(currentReachabilityStatus)
                                         andReturn:theValue(ReachableViaWiFi)
                                  withCountAtLeast:1];
                EMSConnectionWatchdog *watchdog = [[EMSConnectionWatchdog alloc] initWithReachability:reachabilityMock
                                                                                       operationQueue:queue];

                __block NSOperationQueue *result;
                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForExpectation"];

                FakeConnectionChangeListener *listener = [[FakeConnectionChangeListener alloc] initWithCompletionBlock:^(NSOperationQueue *currentQueue) {
                    result = currentQueue;
                    [exp fulfill];
                }];
                watchdog.connectionChangeListener = listener;

                waitForOperationQueue();

                [[NSNotificationCenter defaultCenter] postNotificationName:kEMSReachabilityChangedNotification
                                                                    object:reachabilityMock];

                [EMSWaiter waitForExpectations:@[exp]
                                       timeout:10];

                [[result should] equal:queue];

                [[NSNotificationCenter defaultCenter] removeObserver:watchdog.notificationToken];
            });
        });

SPEC_END
