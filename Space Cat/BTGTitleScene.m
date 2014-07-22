//
//  BTGTitleScene.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGTitleScene.h"
#import "BTGGamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface BTGTitleScene ()
@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer	*backgroundMusic;
@end

@implementation BTGTitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
		/* Setup your scene here */
		[self setupBackground];
		[self setupSoundEffects];
		[self setupBackgroundMusic];
    }
    return self;
}

/*=================================
Scene Setup
=================================*/
- (void) setupBackground {
	SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
	background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
	[self addChild:background];
}

- (void) setupBackgroundMusic {
	
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
	self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	self.backgroundMusic.numberOfLoops = -1; // Play infinitely
	[self.backgroundMusic prepareToPlay];
	
}

- (void) setupSoundEffects {
	self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
}


/*=================================
 SKScene Implementation
 =================================*/
- (void) didMoveToView:(SKView *)view {
	[self.backgroundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.backgroundMusic stop];
	[self runAction:self.pressStartSFX];
    BTGGamePlayScene *gamePlayScene = [BTGGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
