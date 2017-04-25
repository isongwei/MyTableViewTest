//
//  main.m
//  MyTableView
//
//  Created by iSongWei on 2017/4/25.
//  Copyright © 2017年 iSong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        setenv("OS_ACTIVITY_MODE", "DISABLE", 1);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
