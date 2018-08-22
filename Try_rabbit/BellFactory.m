//
//  BellFactory.m
//  Try_rabbit
//
//  Created by irons on 2015/10/7.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "BellFactory.h"

int bellWidth = 60;
int bellHeight = 60;
int minDistanceX = (int) (bellWidth*2);
int maxDistanceX = (int) (bellWidth*3.5);
int minDistanceY = (int) (MyRabbit.SPEED_JUMP/2.5 * MyRabbit.SPEED_JUMP/MyRabbit.speedG);
int maxDistanceY = (int)(MyRabbit.SPEED_JUMP/1.6 * MyRabbit.SPEED_JUMP/MyRabbit.speedG);

@implementation BellFactory{
    
}

-(void) initeBellFactory(float rabbitY, List<MyBell> bells){
    baseMyBellToCalculateNextRowY = new MyBell(null, 0, 0, false);
    baseMyBellToCalculateNextRowY.setPosition(0, rabbitY);
    this.bells = bells;
}

-(MyBell*) createBell(){
    return createBell(bells);
}

-(MyBell) createBell(List<MyBell> bells){
    Point newBellXY;
    if(bells.size()==0){
        newBellXY = randomFirstBellXY();
    }else{
        newBellXY = randomNextBellXY(bells.get(bells.size()-1));
    }
    
    MyBell myBell = new MyBell(BitmapUtil.getBitmapFromRes(R.drawable.bell_ok), bellWidth, bellHeight, true);
    myBell.setPosition(newBellXY.x, newBellXY.y);
    return myBell;
}

-(Point) randomFirstBellXY(){
    return createNextBellXY(baseMyBellToCalculateNextRowY);
}

-(Point) randomNextBellXY(MyBell currentBell){
    //		int currentBellX = (int) currentBell.x;
    //		int currentBellY = (int) currentBell.y;
    
    //		return createNextBellXY(currentBellX, currentBellY);
    return createNextBellXY(currentBell);
}

-(Point) createNextBellXY(MyBell currentBell){
    Point point = new Point();
    Random random = new Random();
    int currentBellX = (int) currentBell.getX();
    int currentBellY = (int) currentBell.getY();
    int x = random.nextInt(maxDistanceX - minDistanceX) + minDistanceX + currentBellX;
    int y;
    if(x > CommonUtil.screenWidth - bellWidth){
        baseMyBellToCalculateNextRowY = currentBell;
        x -= (CommonUtil.screenWidth - bellWidth);
        Log.e("X", x+"");
        y = currentBellY - (random.nextInt(maxDistanceY - minDistanceY) + minDistanceY);
    }else{
        y = (int) (baseMyBellToCalculateNextRowY.getY() - (random.nextInt(maxDistanceY - minDistanceY) + minDistanceY));
    }
    point.set(x, y);
    return point;
}

@end
