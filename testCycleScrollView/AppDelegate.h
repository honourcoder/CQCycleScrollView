//
//  AppDelegate.h
//  testCycleScrollView
//
//  Created by CoderQi on 2018/4/23.
//  Copyright © 2018年 CoderQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

