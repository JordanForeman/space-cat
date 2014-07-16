//
//  BTGProjectileNode.h
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BTGProjectileNode : SKSpriteNode

+ (instancetype) projectileAtPosition:(CGPoint)position;
- (void) setupAnimation;
- (void) moveTowardsPosition:(CGPoint)position;

@end
