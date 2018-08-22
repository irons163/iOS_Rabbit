//
//  Bell.m
//  Try_rabbit
//
//  Created by irons on 2015/4/23.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "Bell.h"
#import "TextureHelper.h"

@implementation Bell

-(id)init{
    if(self = [super init]){
        
        NSArray *hand;
        
        int r = arc4random_uniform(10);
        
        if(r==0){
            hand = TextureHelper.hand3Textures;
        }else if(r==1){
            hand = TextureHelper.hand2Textures;
        }else {
            hand = TextureHelper.hand1Textures;
        }
        
//        switch (r) {
//            case 1:
//                hand = TextureHelper.hand1Textures;
//                break;
//            case 2:
//                hand = TextureHelper.hand2Textures;
//                break;
//            case 3:
//                hand = TextureHelper.hand3Textures;
//                break;
//            default:
//                break;
//        }
        
        self.texture = hand[0];
    }
    return self;
}

-(void)explode{
    
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"explode" withinNode:nil sourceRect:CGRectMake(0, 0, 500, 500) andRowNumberOfSprites:1 andColNumberOfSprites:5];
    
    SKAction * explodeAction = [SKAction animateWithTextures:nsArray timePerFrame:0.2];
    
    SKAction * end = end = [SKAction runBlock:^{
        [self removeFromParent];
    }];
    
    [self runAction:[SKAction sequence:@[explodeAction, end]]];
}

-(void)e{
    
}

@end
