//
//  BTGSpaceDogNode.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/18/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGSpaceDogNode.h"
#import "BTGUtil.h"

@implementation BTGSpaceDogNode

+ (instancetype) spaceDogOfType:(BTGSpaceDogType)type {
	BTGSpaceDogNode *spaceDog;
	
	NSArray *textures;
	
	if (type == BTGSpaceDogTypeA) {
		spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
		textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
					 [SKTexture textureWithImageNamed:@"spacedog_A_2"],
					 [SKTexture textureWithImageNamed:@"spacedog_A_3"]];
		spaceDog.dogType = BTGSpaceDogTypeA;
	} else {
		spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
		textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
					 [SKTexture textureWithImageNamed:@"spacedog_B_2"],
					 [SKTexture textureWithImageNamed:@"spacedog_B_3"],
					 [SKTexture textureWithImageNamed:@"spacedog_B_4"]];
		spaceDog.dogType = BTGSpaceDogTypeB;
	}
	
	float scale = [BTGUtil randomWithMin:85 max:100] / 100.0f;
	spaceDog.xScale = scale;
	spaceDog.yScale = scale;
	
	spaceDog.isDamaged = NO;
	
	SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
	[spaceDog runAction:[SKAction repeatActionForever:animation]];
	
	[spaceDog setupPhysicsBody];
	
	return spaceDog;
}

- (void) damage {
	self.isDamaged = YES;
	[self removeAllActions];
	
	if (self.dogType == BTGSpaceDogTypeA) {
		// Type A
		[self setTexture:[SKTexture textureWithImageNamed:@"spacedog_A_3"]];
	} else {
		// Type B
		[self setTexture:[SKTexture textureWithImageNamed:@"spacedog_B_4"]];
	}
}

- (void) setupPhysicsBody {
	self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
	self.physicsBody.affectedByGravity = NO;
	self.physicsBody.categoryBitMask = BTGCollisionCategoryEnemy;
	self.physicsBody.collisionBitMask = 0;
	self.physicsBody.contactTestBitMask = BTGCollisionCategoryProjectile | BTGCollisionCategoryGround; // 0010 | 1000 = 1010
}

@end
