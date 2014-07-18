//
//  BTGGamePlayScene.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGGamePlayScene.h"
#import "BTGMachineNode.h"
#import "BTGSpaceCatNode.h"
#import "BTGProjectileNode.h"
#import "BTGSpaceDogNode.h"
#import "BTGGroundNode.h"
#import "BTGUtil.h"

@implementation BTGGamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
		
		BTGMachineNode *machine = [BTGMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
		[self addChild:machine];
		
		BTGSpaceCatNode *spaceCat = [BTGSpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y)];
		[self addChild:spaceCat];
		
		[self addSpaceDog];
		
		self.physicsWorld.gravity = CGVectorMake(0, -9.8);
		self.physicsWorld.contactDelegate = self;
		
		BTGGroundNode *ground = [BTGGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
		[self addChild: ground];
    }
    return self;
}

- (void) update:(NSTimeInterval)currentTime {
	//TODO:
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		CGPoint position = [touch locationInNode:self];
		[self shootProjectileTowardsPosition:position];
		[self animateSpaceCat];
	}
	
}

- (void) animateSpaceCat {
	BTGSpaceCatNode *spaceCat = (BTGSpaceCatNode *)[self childNodeWithName:@"SpaceCat"];
	[spaceCat performTap];
}

- (void) shootProjectileTowardsPosition:(CGPoint)position {
	BTGMachineNode *machine = (BTGMachineNode *)[self childNodeWithName:@"Machine"];
	
	BTGProjectileNode *projectile = [BTGProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height - 15)];
	[self addChild:projectile];
	[projectile moveTowardsPosition:position];
}

- (void) addSpaceDog {
	BTGSpaceDogNode *spaceDogA = [BTGSpaceDogNode spaceDogOfType:BTGSpaceDogTypeA];
	spaceDogA.position = CGPointMake(100, 300);
	[self addChild:spaceDogA];
	
	BTGSpaceDogNode *spaceDogB = [BTGSpaceDogNode spaceDogOfType:BTGSpaceDogTypeB];
	spaceDogB.position = CGPointMake(200, 300);
	[self addChild:spaceDogB];
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
	SKPhysicsBody *firstBody, *secondBody;
	
	if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
		firstBody = contact.bodyA;
		secondBody = contact.bodyB;
	} else {
		firstBody = contact.bodyB;
		secondBody = contact.bodyA;
	}
	
	if (firstBody.categoryBitMask == BTGCollisionCategoryEnemy
		&& secondBody.categoryBitMask == BTGCollisionCategoryProjectile) {
		
		BTGSpaceDogNode *spaceDog = (BTGSpaceDogNode *)firstBody.node;
		BTGProjectileNode *projectile = (BTGProjectileNode *)secondBody.node;
		
		[spaceDog removeFromParent];
		[projectile removeFromParent];
		
		[self createDebrisAtPosition:contact.contactPoint];
		
	} else if (firstBody.categoryBitMask == BTGCollisionCategoryEnemy
			   && secondBody.categoryBitMask == BTGCollisionCategoryGround) {
		
		BTGSpaceDogNode *spaceDog = (BTGSpaceDogNode *)firstBody.node;
		[spaceDog removeFromParent];
	}
}

- (void) createDebrisAtPosition:(CGPoint)position {
	NSInteger numberOfPieces = [BTGUtil randomWithMin:5 max:20];
	
	for (int i = 0; i < numberOfPieces; i++) {
		NSInteger randomPiece = [BTGUtil randomWithMin:1 max:4];
		NSString *imageName = [NSString stringWithFormat:@"debri_%d", randomPiece];
		
		SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
		debris.position = position;
		[self addChild:debris];
		
		debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
		debris.physicsBody.categoryBitMask = BTGCollisionCategoryDebris;
		debris.physicsBody.contactTestBitMask = 0;
		debris.physicsBody.collisionBitMask = BTGCollisionCategoryGround | BTGCollisionCategoryDebris;
		debris.name = @"Debris";
		
		debris.physicsBody.velocity = CGVectorMake([BTGUtil randomWithMin:-150 max:150],
												   [BTGUtil randomWithMin:150 max:350]);
		
		[debris runAction:[SKAction waitForDuration:2.0] completion:^{
			[debris removeFromParent];
		}];
	}
}

@end
