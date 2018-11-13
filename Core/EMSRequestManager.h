//
//  Copyright (c) 2017 Emarsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSCoreCompletion.h"
#import "EMSRequestModelRepositoryProtocol.h"
#import "EMSShardRepositoryProtocol.h"
#import "EMSLogRepositoryProtocol.h"
#import "EMSBlocks.h"
#import "EMSCompletionMiddleware.h"
#import "EMSWorkerProtocol.h"
#import "EMSRESTClient.h"

@class EMSRequestModel;

NS_ASSUME_NONNULL_BEGIN

@interface EMSRequestManager : NSObject

@property(nonatomic, readonly) id <EMSRequestModelRepositoryProtocol> requestModelRepository;
@property(nonatomic, readonly) id <EMSShardRepositoryProtocol> shardRepository;
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> *additionalHeaders;

- (instancetype)initWithCoreQueue:(NSOperationQueue *)coreQueue
             completionMiddleware:(EMSCompletionMiddleware *)completionMiddleware
                       restClient:(EMSRESTClient *)restClient
                           worker:(id <EMSWorkerProtocol>)worker
                requestRepository:(id <EMSRequestModelRepositoryProtocol>)requestRepository
                  shardRepository:(id <EMSShardRepositoryProtocol>)shardRepository;

- (void)submitRequestModel:(EMSRequestModel *)model
       withCompletionBlock:(EMSCompletionBlock)completionBlock;

- (void)submitShard:(EMSShard *)shard;

- (void)submitRequestModelNow:(EMSRequestModel *)model
          withCompletionBlock:(EMSCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END