//
//  AssetLibraryUtility.h
//  MySharingApp
//
//  Created by Rahul Mane on 04/11/15.
//  Copyright © 2015 Rahul Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetLibraryUtility : NSObject

+ (instancetype)sharedInstance;

-(NSMutableArray *)getAllAssets;

@end
