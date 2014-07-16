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



@end
