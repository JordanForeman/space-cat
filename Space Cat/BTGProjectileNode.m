//
//  BTGProjectileNode.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGProjectileNode.h"
#import "BTGUtil.h"

@implementation BTGProjectileNode

+ (instancetype) projectileAtPosition:(CGPoint)position {
	BTGProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
	projectile.position = position;
	projectile.name	= @"Projectile";
	
	[projectile setupAnimation];
	 
	return projectile;
}

- (void) setupAnimation {
	NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
						  [SKTexture textureWithImageNamed:@"projectile_2"],
						  [SKTexture textureWithImageNamed:@"projectile_3"]];
	
	SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
	SKAction *repeatAction = [SKAction repeatActionForever:animation];
	
	[self runAction:repeatAction];
}

- (void) moveTowardsPosition:(CGPoint)position {
	// Slope = (Y3 - Y1) / (X3 - X1)
	float slope = (position.y - self.position.y) / (position.x - self.position.x);
	
	// Slope = (Y2 - Y1) / (X2 - X1)
	// Y2 - Y1 = Slope (X2 - X1)
	// Y2 = Slope * X2 - Slope * X1 + Y1
	
	float offscreenX;
	if (position.x <= self.position.x) {
		offscreenX = -10;
	} else {
		offscreenX = self.parent.frame.size.width + 10;
	}
	
	float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
	
	CGPoint pointOffScreen = CGPointMake(offscreenX, offscreenY);
	
	float distanceA = pointOffScreen.y - self.position.y;
	float distanceB = pointOffScreen.x - self.position.x;
	
	float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
	
	// distance = speed * time
	// time = distance / speed
	
	float time = distanceC / BTGProjectileSpeed;
	float waitToFade = time * 0.75;
	float fadeTime = time - waitToFade;
	
	SKAction *moveProjectile = [SKAction moveTo:pointOffScreen duration:time];
	[self runAction:moveProjectile];
	
	SKAction *projectileFadeDelay = [SKAction waitForDuration:waitToFade];
	SKAction *fadeProjectile = [SKAction fadeOutWithDuration:fadeTime];
	SKAction *fadeSequence = [SKAction sequence:@[projectileFadeDelay,
												  fadeProjectile,
												  [SKAction removeFromParent]]];
	[self runAction:fadeSequence];
}

@end
