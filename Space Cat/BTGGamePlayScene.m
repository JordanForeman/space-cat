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
#import "BTGHUDNode.h"

#import <AVFoundation/AVFoundation.h>

@interface BTGGamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;

@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;

@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation BTGGamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
		/* Setup your scene here */
		self.lastUpdateTimeInterval = 0;
		self.timeSinceEnemyAdded = 0;
		self.addEnemyTimeInterval = 1.5;
		self.totalGameTime = 0;
		self.minSpeed = BTGSpaceDogMinSpeed;
		
		[self setupInitialNodes];
		[self setupPhysics];
		[self setupSounds];
    }
    return self;
}

/*=================================
 Scene Setup
 =================================*/
- (void) setupInitialNodes {
	
	SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
	background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
	[self addChild:background];
	
	BTGMachineNode *machine = [BTGMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
	[self addChild:machine];
	
	BTGSpaceCatNode *spaceCat = [BTGSpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y)];
	[self addChild:spaceCat];
	
	BTGGroundNode *ground = [BTGGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
	[self addChild: ground];
	
	BTGHUDNode *hud = [BTGHUDNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
	[self addChild:hud];
	
}

- (void) setupPhysics {
	self.physicsWorld.gravity = CGVectorMake(0, -9.8);
	self.physicsWorld.contactDelegate = self;
}

- (void) setupSounds {
	
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
	
	self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	self.backgroundMusic.numberOfLoops = -1; // Play infinitely
	[self.backgroundMusic prepareToPlay];
	
	self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
	self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
	self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
}

/*=================================
SKScene Implementation
 =================================*/
- (void) didMoveToView:(SKView *)view {
	[self.backgroundMusic play];
}

- (void) update:(NSTimeInterval)currentTime {
	
	// Update Time Trackers
	if ( self.lastUpdateTimeInterval ) {
		self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
		self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
	}
	
	// Add SpaceDogs
	if ( self.timeSinceEnemyAdded > self.addEnemyTimeInterval) {
		[self addSpaceDog];
		self.timeSinceEnemyAdded = 0;
	}
	
	[self alterDifficultyIfApplicable];
	
	self.lastUpdateTimeInterval = currentTime;
	
}

- (void) alterDifficultyIfApplicable {
	// The game gets more difficult as time goes by
	if ( self.totalGameTime > 480 ) {
		// 480 / 60 = 8 minutes
		self.addEnemyTimeInterval = 0.50;
		self.minSpeed = -160;
	} else if ( self.totalGameTime > 240 ) {
		// 240 / 60 = 4 minutes
		self.addEnemyTimeInterval = 0.65;
		self.minSpeed = -150;
	} else if ( self.totalGameTime > 20 ) {
		// 120 / 60 = 2 minutes
		self.addEnemyTimeInterval = 0.75;
		self.minSpeed = -125;
	} else if ( self.totalGameTime > 10 ) {
		self.addEnemyTimeInterval = 1.00;
		self.minSpeed = -100;
	}
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
	[self runAction:self.laserSFX];
	[projectile moveTowardsPosition:position];
}

- (void) addSpaceDog {
	NSUInteger randomSpaceDog = [BTGUtil randomWithMin:0 max:2];
	
	BTGSpaceDogNode *spaceDog = [BTGSpaceDogNode spaceDogOfType:randomSpaceDog];
	float y = self.frame.size.height + spaceDog.frame.size.height;
	float x = [BTGUtil randomWithMin:10 + spaceDog.size.width
								 max:self.frame.size.width - 10 - spaceDog.size.width];
	spaceDog.position = CGPointMake(x, y);
	
	float dy = [BTGUtil randomWithMin:BTGSpaceDogMinSpeed max:BTGSpaceDogMaxSpeed];
	spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
	[self addChild:spaceDog];
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
		[self projectileHitEnemy:contact];
	} else if (firstBody.categoryBitMask == BTGCollisionCategoryEnemy
			   && secondBody.categoryBitMask == BTGCollisionCategoryGround) {
		[self enemyHitPlayer:contact];
	}
}

- (void) projectileHitEnemy:(SKPhysicsContact*)contact {
	
	SKPhysicsBody *firstBody = contact.bodyA;
	SKPhysicsBody *secondBody = contact.bodyB;
	
	BTGSpaceDogNode *spaceDog = (BTGSpaceDogNode *)firstBody.node;
	BTGProjectileNode *projectile = (BTGProjectileNode *)secondBody.node;
	
	[self addPoints:BTGPointsPerHit];
	
	if ( spaceDog.isDamaged ) {
		// Kill it with fire!
		[spaceDog removeFromParent];
		[self createDebrisAtPosition:contact.contactPoint];
		[self createExplosionAtPosition:contact.contactPoint];
	} else {
		[spaceDog damage];
	}
	
	[self runAction:self.explodeSFX];
	
	[projectile removeFromParent];
	
}

- (void) enemyHitPlayer:(SKPhysicsContact*)contact {
	
	SKPhysicsBody *firstBody = contact.bodyB;
	//SKPhysicsBody *secondBody = contact.bodyA;
	
	BTGSpaceDogNode *spaceDog = (BTGSpaceDogNode *)firstBody.node;
	
	[self runAction:self.damageSFX];
	[spaceDog removeFromParent];
	[self loseLife];
	
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

- (void) addPoints:(NSInteger)points {
	BTGHUDNode *hud = (BTGHUDNode*)[self childNodeWithName:@"hud"];
	[hud addPoints:points];
}

- (void) loseLife {
	BTGHUDNode *hud = (BTGHUDNode*)[self childNodeWithName:@"hud"];
	[hud loseLife];
}

- (void) createExplosionAtPosition:(CGPoint)position {
	
	// EXPLOSIOOOOON!!!1! #metal
	NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
	SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
	explosion.position = position;
	[self addChild:explosion];
	[explosion runAction:[SKAction waitForDuration:2.0] completion:^{
		[explosion removeFromParent];
	}];
	
}

@end
