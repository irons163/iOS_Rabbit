//
//  MyScene.m
//  Try_rabbit
//
//  Created by irons on 2015/4/23.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "TextureHelper.h"
#import "Bell.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer   = 0x1 << 0,
    CollisionCategoryStar     = 0x1 << 1,
    CollisionCategoryPlatform = 0x1 << 2,
};

@implementation MyScene{
    int playerInitX, playerInitY;
    int backgroundMovePointsPerSec;
    Boolean isGameRun;
    int ccount;
    int gameLevel;
    SKSpriteNode * backgroundNode, * backgroundNode2;
    SKSpriteNode * player;
    SKSpriteNode * controller;
    SKSpriteNode * textureBox;
    //    SKSpriteNode * coin;
    SKSpriteNode * coin10, * coin30, * coin50;
    SKSpriteNode * controlPoint;
    SKLabelNode * gameLevelNode;
    SKSpriteNode * buttonNode;
    
    SKSpriteNode * panel;
    SKSpriteNode * itemBar;
    SKSpriteNode * item1, * item2, * item3;
    SKSpriteNode * skillArea;
    SKSpriteNode * infoArea;
    SKSpriteNode * groundNode;
    SKNode *_hudNode;
    // Tap To Start node
    SKSpriteNode *_tapToStartNode;
    
    Bell * bell;
    
    NSMutableArray * scoreArray;
    NSMutableArray * contactQueue;
    

}

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;
static const uint32_t toolCategory        =  0x1 << 2;
static const uint32_t catCategory        =  0x1 << 3;
static const uint32_t hamsterCategory        =  0x1 << 5;
static const uint32_t coinCategory        =  0x1 << 6;
static const uint32_t groundCategory        =  0x1 << 7;
static int barInitX, barInitY;
bool isShootEnable = false;

bool isMoveBar = false;

bool isMoveAble = true;

CGPoint p;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.physicsWorld.gravity = CGVectorMake(0,-0.1);
        self.physicsWorld.contactDelegate = self;
        
        backgroundMovePointsPerSec = 40;
        
        isGameRun = true;
        
        [TextureHelper initTextures];
        
        [TextureHelper initHandTexturesSourceRect:CGRectMake(0, 0, 117, 105) andRowNumberOfSprites:2 andColNumberOfSprites:7];
        
        NSArray *hand;
        
        int r = arc4random_uniform(3)+1;
        
        switch (r) {
            case 1:
                hand = TextureHelper.hand1Textures;
                break;
            case 2:
                hand = TextureHelper.hand2Textures;
                break;
            case 3:
                hand = TextureHelper.hand3Textures;
                break;
            default:
                break;
        }
        
        SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:hand timePerFrame:0.08]];
        
        [self runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        contactQueue = [[NSMutableArray alloc] init];
        
//        backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"bg03.jpg"];
//        
//        backgroundNode.size = self.frame.size;
//        backgroundNode.anchorPoint = CGPointMake(0, 0);
//        backgroundNode.position = CGPointMake(0, 0);
        
        [self getBackground];
        
        [self addChild:backgroundNode];
        
        panel = [SKSpriteNode spriteNodeWithImageNamed:@"frame"];
        
        panel.size = CGSizeMake(60, 60);
        
        playerInitX = player.size.width/2;
        playerInitY = player.size.height + 40;
        panel.position = CGPointMake(playerInitX, playerInitY);
        
        
        [self addChild:panel];
        
        
        //        [panel addChild:];
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                                                  sequence:@[@7]];
        
        //        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        player = [SKSpriteNode spriteNodeWithTexture:nsArray[0]];
        
        player.size = CGSizeMake(60, 60);
        
        playerInitX = player.size.width/2;
        playerInitY = player.size.height + 40;
        player.position = CGPointMake(playerInitX, playerInitY);
        
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
        player.physicsBody.dynamic = YES;
        player.physicsBody.categoryBitMask = hamsterCategory;
        player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
        player.physicsBody.collisionBitMask = 0;
        
        [self addChild:player];
        
        controlPoint = [SKSpriteNode spriteNodeWithImageNamed:@"control_point"];
        controlPoint.size = CGSizeMake(50, 50);
        //        barInitX = self.controlPoint.size.width/2;
        barInitX = playerInitX;
        barInitY = controlPoint.size.height;
        controlPoint.position = CGPointMake(barInitX, barInitY);
        [self addChild:controlPoint];
        
        
        textureBox = [SKSpriteNode spriteNodeWithImageNamed:@"s0"];
        textureBox.size = CGSizeMake(100, 100);
        textureBox.position = CGPointMake(200, 400);
        
        
        //        SKAction * upaction = [SKAction ];
        
        SKAction* upAction = [SKAction moveByX:0 y:50 duration:0.5];
        upAction.timingMode = SKActionTimingEaseOut;
        SKAction* downAction = [SKAction moveByX:0 y:-50 duration: 0.5]; downAction.timingMode = SKActionTimingEaseIn;
        // 3
        //        topNode.runAction(SKAction.sequence(
        //                                            [upAction, downAction, SKAction.removeFromParent()]))
        
        SKAction* upEnd = [SKAction runBlock:^{
            //            sheep.texture = [SKTexture textureWithImageNamed:@"sheep_jump3"];
        }];
        
        SKAction* horzAction = [SKAction moveToX:50 duration:1.0];
        
        SKAction * end;
        
        end = [SKAction runBlock:^{
            [coin10 removeAllActions];
        }];
        
        [self addChild:textureBox];
        
        coin10 = [SKSpriteNode spriteNodeWithImageNamed:@"coin_10_btn01"];
        coin10.size = CGSizeMake(50, 50);
        coin10.position = CGPointMake(100 + coin10.size.width, 0);
        
        [self addChild:coin10];
        
        [coin10 runAction:[SKAction group:@[[SKAction sequence:@[upAction, upEnd, downAction, end]], horzAction]]];
        
        coin30 = [SKSpriteNode spriteNodeWithImageNamed:@"coin_30_btn01"];
        coin30.size = CGSizeMake(50, 50);
        coin30.position = CGPointMake(100 + coin30.size.width*2, 100);
        
        [self addChild:coin30];
        
        coin50 = [SKSpriteNode spriteNodeWithImageNamed:@"coin_50_btn01"];
        coin50.size = CGSizeMake(50, 50);
        coin50.position = CGPointMake(100 + coin50.size.width*3, 100);
        
        [self addChild:coin50];
        
        groundNode = [SKSpriteNode spriteNodeWithImageNamed:@"info_bar"];
        groundNode.size = CGSizeMake(500, 30);
        groundNode.position = CGPointMake(100, 50);
        
        groundNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:groundNode.size];
//        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
        
        groundNode.physicsBody.dynamic = NO;
        groundNode.physicsBody.affectedByGravity = false;
        groundNode.physicsBody.angularDamping = false;
        groundNode.physicsBody.density = 100;
//        groundNode.physicsBody.
        groundNode.physicsBody.categoryBitMask = groundCategory;
        
        player.physicsBody.dynamic = YES;
        
        [self addChild:groundNode];
        
        bell = [Bell spriteNodeWithImageNamed:@"control_point"];
//        bell = [Bell spriteNodeWithTexture:nil];
        bell.size = CGSizeMake(50, 50);
        bell.position = CGPointMake(100, 100);
        
        [self addChild:bell];
        
        [self createbirdAndAction];
        
        
        // HUD
        _hudNode = [SKNode node];
        [self addChild:_hudNode];
        
        // Tap to Start
        _tapToStartNode = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
        _tapToStartNode.position = CGPointMake(160, 180.0f);
        [_hudNode addChild:_tapToStartNode];
    }
    return self;
}

-(void)getBackground{
    backgroundNode = [SKSpriteNode spriteNodeWithTexture:nil];
    backgroundNode.anchorPoint = CGPointZero;
    
    SKSpriteNode * bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg01.jpg"];
    bg1.anchorPoint = CGPointZero;
    bg1.size = self.frame.size;
    bg1.position = CGPointMake(0, 0);
    
    [backgroundNode addChild:bg1];
    
    SKSpriteNode * bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg02.jpg"];
    bg2.anchorPoint = CGPointZero;
    bg2.size = self.frame.size;
    bg2.position = CGPointMake(0, bg1.size.height);
    
    [backgroundNode addChild:bg2];
    
    backgroundNode.size = CGSizeMake(bg1.size.width, bg1.size.height + bg2.size.height);
    backgroundNode.name = @"background";
    
    backgroundNode2 = [backgroundNode copy];
    backgroundNode2.position = CGPointMake(0, backgroundNode.size.height);
    [self addChild: backgroundNode2];
}

-(void)moveBg{
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.y <= -node.frame.size.height) {
            node.position = CGPointMake(node.position.x, node.position.y + node.frame.size.height*2);
        }
        
        CGPoint backgroundVelocity = CGPointMake(0, -backgroundMovePointsPerSec);
//        CGPoint amountToMove = backgroundVelocity;
        node.position = CGPointMake(node.position.x + backgroundVelocity.x, node.position.y + backgroundVelocity.y);
        
    }];
}

////////////////
-(void)bellExplode:(Bell*)bell{
//    SKSpriteNode *explode = [SKSpriteNode spriteNodeWithTexture:nil size:CGSizeMake(100, 100)];
    
    
    
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"explode" withinNode:nil sourceRect:CGRectMake(0, 0, 500, 500) andRowNumberOfSprites:1 andColNumberOfSprites:5];
    
//    explode.position = bell.position;
    
    SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.2];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [bell runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
    
//    [self addChild:explode];
}

-(void)createbirdAndAction{
    
    
    
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                         //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                              sequence:@[@3,@4,@5,@4,@3,@2]];
    
    SKAction * monsterAnimation = [SKAction repeatAction:[SKAction animateWithTextures:nsArray timePerFrame:0.1] count:10];
    
    SKAction * move = [SKAction moveToX:0 duration:10];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
    
    SKSpriteNode * bird = [SKSpriteNode spriteNodeWithTexture:nsArray[0]];
    bird.size = CGSizeMake(50, 50);
    bird.position = CGPointMake(self.size.width, 300);
    
    [self addChild:bird];
    
    [bird runAction:[SKAction sequence:@[[SKAction group:@[monsterAnimation, move]], actionMoveDone]]];
}

-(void)coin:(SKSpriteNode *) coin didCollideWithHamster:(SKSpriteNode *) hamster{
    
    if(coin.hidden||coin==nil){
        return;
    }
    
    coin.hidden = true;
    
    [coin removeFromParent];
    coin = nil;
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [contactQueue addObject:contact];
    
}

-(void)processContactsForUpdate
{
    for (SKPhysicsContact * contact in [contactQueue copy]) {
        [self handleContact:contact];
        [contactQueue removeObject:contact];
    }
}

-(void) handleContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact");
    // What you are doing in your current didBeginContact method
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & hamsterCategory) != 0 &&
        (secondBody.categoryBitMask & coinCategory) != 0)
    {
        NSLog(@"will do didCollideWithMonster");
        [self coin:(SKSpriteNode *) secondBody.node didCollideWithHamster:(SKSpriteNode *) firstBody.node];
    }
}

-(void)jump{
    player.texture = [SKTexture textureWithImageNamed:@"sheep_jump1"];
    player.xScale = 1;
    
    SKAction* upAction = [SKAction moveByX:0 y:50 duration:0.5];
    upAction.timingMode = SKActionTimingEaseOut;
    SKAction* downAction = [SKAction moveByX:0 y:-50 duration: 0.5]; downAction.timingMode = SKActionTimingEaseIn;
    // 3
    //        topNode.runAction(SKAction.sequence(
    //                                            [upAction, downAction, SKAction.removeFromParent()]))
    
    SKAction* upEnd = [SKAction runBlock:^{
        player.texture = [SKTexture textureWithImageNamed:@"sheep_jump3"];
    }];
    
    SKAction* horzAction = [SKAction moveToX:50 duration:1.0];
    
    [player runAction:[SKAction group:@[[SKAction sequence:@[upAction, upEnd, downAction]], horzAction]]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGRect rect = [controlPoint calculateAccumulatedFrame];
    bool isCollision = CGRectContainsPoint(rect, location);
    if(isCollision){
        p = location;
        isMoveBar = true;
        isShootEnable = true;
    }
    
//    [self changeBG];
    gameLevel++;
    
    [self bellExplode:bell];
    
    if (CGRectContainsPoint(coin30.calculateAccumulatedFrame, location)) {
        [self jump];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isMoveBar && isMoveAble){
        
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        CGFloat offx = location.x - p.x;
        CGPoint position = controlPoint.position;
        position.x = position.x + offx;
        controlPoint.position = position;
        
        position = player.position;
        position.x = position.x + offx;
        player.position = position;
        
        p = location;
        
        //        fire.position = player.position;
        
        if(offx > 8){
            player.xScale = -1;
            
            player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
            player.physicsBody.dynamic = YES;
            player.physicsBody.categoryBitMask = hamsterCategory;
            player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
            player.physicsBody.collisionBitMask = 0;
            player.physicsBody.usesPreciseCollisionDetection = YES;
            
            TextureHelper *textureHelper = [TextureHelper alloc];
            
            NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                 //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                                      sequence:@[@3,@4,@5,@4,@3,@2]];
            
            SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.1];
            
            SKAction * actionMoveDone = [SKAction removeFromParent];
            
            //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
            
            [player runAction:monsterAnimation];
            
        }else if(offx <-8){
            player.xScale = 1;
            
            player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
            player.physicsBody.dynamic = YES;
            player.physicsBody.categoryBitMask = hamsterCategory;
            player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
            player.physicsBody.collisionBitMask = 0;
            player.physicsBody.usesPreciseCollisionDetection = YES;
            
            TextureHelper *textureHelper = [TextureHelper alloc];
            
            NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                 //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                                      sequence:@[@3,@4,@5,@4,@3,@2]];
            
            SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.1];
            
            SKAction * actionMoveDone = [SKAction removeFromParent];
            
            //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
            
            [player runAction:monsterAnimation];
            
        }
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if(!isGameRun)
        return;
    
    /* Called before each frame is rendered */
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // 如果上次更新后得时间增量大于1秒
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    
    [self processContactsForUpdate];
    
    if (self.lastSpawnTimeInterval > 0.5) {
        self.lastSpawnTimeInterval = 0;
        
        ccount++;
        
        if(ccount==1)    {
            
            int continueAttackCounter = 0;
            
            int r = arc4random_uniform(40);
            
            
//            [self randomNewCoin];
            
            [self moveBg];
            
            ccount = 0;
        }
        
    }else if(self.lastSpawnTimeInterval > 0.3){
        
    }
    
    
}

@end
