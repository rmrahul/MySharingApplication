//
//  AssetLibraryUtility.m
//  MySharingApp
//
//  Created by Rahul Mane on 04/11/15.
//  Copyright © 2015 Rahul Mane. All rights reserved.
//

#import "AssetLibraryUtility.h"
@import AssetsLibrary;

@implementation AssetLibraryUtility{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *arrayOfGroups;
    NSMutableArray *arrayOfAssets;

}

-(id)init{
    self=[super init];
    if(self){
        
        [self setUp];
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark - SetUp
#pragma mark -

-(void)setUp{
    [self setUpAssetLibrary];
}

-(void)setUpAssetLibrary{
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    arrayOfAssets=[[NSMutableArray alloc]init];

    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allAssets];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            [arrayOfGroups addObject:group];
            [self enumratePhotos:group];

        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}


-(void)enumratePhotos:(ALAssetsGroup *)group{
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [arrayOfAssets addObject:result];
        }
    };
    
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allAssets];
    [group setAssetsFilter:onlyPhotosFilter];
    [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
}


-(NSMutableArray *)getAllAssets{
    
    return arrayOfAssets;
}
@end
