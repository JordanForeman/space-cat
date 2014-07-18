//
//  BTGSpaceDogNode.h
//  Space Cat
//
//  Created by Jordan Foreman on 7/18/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, BTGSpaceDogType) {
    BTGSpaceDogTypeA = 0,
    BTGSpaceDogTypeB = 1
};

@interface BTGSpaceDogNode : SKSpriteNode

+ (instancetype) spaceDogOfType:(BTGSpaceDogType)type;

@end
