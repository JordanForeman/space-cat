//
//  BTGGroundNode.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/18/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGGroundNode.h"
#import "BTGUtil.h"

@implementation BTGGroundNode

+ (instancetype) groundWithSize:(CGSize)size {
	BTGGroundNode *ground = [self spriteNodeWithColor:[SKColor greenColor] size:size];
	ground.position = CGPointMake(size.width/2, size.height/2);
	ground.name = @"Ground";
	[ground setupPhysicsBody];
	
	return ground;
}

- (void) setupPhysicsBody {
	self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
	self.physicsBody.affectedByGravity = NO;
	self.physicsBody.dynamic = NO;
	self.physicsBody.categoryBitMask = BTGCollisionCategoryGround;
	self.physicsBody.collisionBitMask = BTGCollisionCategoryDebris;
	self.physicsBody.contactTestBitMask = BTGCollisionCategoryEnemy;
}

@end
