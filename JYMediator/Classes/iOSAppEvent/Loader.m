//
//  Loader.m
//  JYMediator
//
//  Created by crazyball on 2023/2/11.
//

#import <Foundation/Foundation.h>

@interface JYAppEventLoader : NSObject
@end

@implementation JYAppEventLoader
+ (void)load {
    Class setupClass = NSClassFromString(@"JYMediator.JYAppDelegate");
    SEL setupSel = NSSelectorFromString(@"startHook");
    if([setupClass respondsToSelector:setupSel]) {
        [setupClass performSelector:setupSel];
    }
}
@end
