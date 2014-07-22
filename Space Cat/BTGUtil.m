//
//  BTGUtil.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGUtil.h"

@implementation BTGUtil

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {
	return arc4random()%(max - min) + min;
}

+ (BTGBuildTarget) getBuildTarget {
	//return BTGDevelopmentBuild;
	return BTGProductionBuild;
}

@end
