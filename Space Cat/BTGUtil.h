//
//  BTGUtil.h
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int BTGProjectileSpeed = 400;

typedef NS_OPTIONS(uint32_t, BTGCollisionCategory) {
    BTGCollisionCategoryEnemy			= 1 << 0,		// 0000
    BTGCollisionCategoryProjectile		= 1 << 1,		// 0010
    BTGCollisionCategoryDebris			= 1 << 2,		// 0100
    BTGCollisionCategoryGround			= 1 << 3,		// 1000
};

@interface BTGUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
