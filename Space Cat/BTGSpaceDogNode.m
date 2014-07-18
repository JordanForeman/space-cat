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
	} else {
		spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
		textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
					 [SKTexture textureWithImageNamed:@"spacedog_B_2"],
					 [SKTexture textureWithImageNamed:@"spacedog_B_3"],
					 [SKTexture textureWithImageNamed:@"spacedog_B_4"]];
	}
	
	SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
	[spaceDog runAction:[SKAction repeatActionForever:animation]];
	
	[spaceDog setupPhysicsBody];
	
	return spaceDog;
}

- (void) setupPhysicsBody {
	self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
	self.physicsBody.affectedByGravity = NO;
	self.physicsBody.velocity = CGVectorMake(0, -50);
	self.physicsBody.categoryBitMask = BTGCollisionCategoryEnemy;
	self.physicsBody.collisionBitMask = 0;
	self.physicsBody.contactTestBitMask = BTGCollisionCategoryProjectile | BTGCollisionCategoryGround; // 0010 | 1000 = 1010
}

@end
