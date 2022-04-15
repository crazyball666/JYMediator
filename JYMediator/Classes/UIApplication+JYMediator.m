//
//  UIApplication+TSMediator.m
//  TSMediator
//
//  Created by HTC on 2022/2/17.
//

#import "UIApplication+JYMediator.h"
#import <objc/runtime.h>
#import <JYMediator/JYMediator-Swift.h>

#ifdef DEBUG
#    define TSLog(...) NSLog(__VA_ARGS__)
#else
#    define TSLog(...) /* */
#endif


static void Hook_Method(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel, SEL noneSel){
    // 原实例方法
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    // 替换的实例方法
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originalMethod) {
        Method noneMethod = class_getInstanceMethod(replacedClass, noneSel);
        BOOL didAddNoneMethod = class_addMethod(originalClass, originalSel, method_getImplementation(noneMethod), method_getTypeEncoding(noneMethod));
        if (didAddNoneMethod) {
            TSLog(@"******** no implementation (%@) method, manually added!",NSStringFromSelector(originalSel));
        }
        originalMethod = class_getInstanceMethod(originalClass, originalSel);
    }
    // 向实现 delegate 的类中添加新的方法
    // 这里是向 originalClass 的 replaceSel（@selector(owner_webViewDidStartLoad:)） 添加 replaceMethod
    BOOL didAddMethod = class_addMethod(originalClass, replacedSel, method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
    // 添加成功
    if (didAddMethod) {
        // 重新拿到添加被添加的 method,这里是关键(注意这里 originalClass, 不 replacedClass), 因为替换的方法已经添加到原类中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        // 实现交换
        method_exchangeImplementations(originalMethod, newMethod);
        TSLog(@"******** Implemented (%@) method and replaced as:(%@)",NSStringFromSelector(originalSel) ,NSStringFromSelector(replacedSel));
    }else{
        // 添加失败，则说明已经 hook 过该类的 delegate 方法，防止多次交换。
        TSLog(@"******** already replaced (%@), skip ...",NSStringFromClass(originalClass));
    }
}


@implementation UIApplication (JYMediator)

+ (void)load {
    Method originalMethod = class_getInstanceMethod([UIApplication class], @selector(setDelegate:));
    Method ownerMethod = class_getInstanceMethod([UIApplication class], @selector(hook_setDelegate:));
    method_exchangeImplementations(originalMethod, ownerMethod);
}

- (void)hook_setDelegate:(id<UIApplicationDelegate>)delegate {
    Hook_Method([delegate class], @selector(application:didFinishLaunchingWithOptions:), [self class], @selector(tsmd_application:didFinishLaunchingWithOptions:), @selector(none_application:didFinishLaunchingWithOptions:));
    Hook_Method([delegate class], @selector(applicationDidBecomeActive:), [self class], @selector(tsmd_applicationDidBecomeActive:), @selector(none_applicationDidBecomeActive:));
    Hook_Method([delegate class], @selector(applicationWillResignActive:), [self class], @selector(tsmd_applicationWillResignActive:), @selector(none_applicationWillResignActive:));
    Hook_Method([delegate class], @selector(applicationDidEnterBackground:), [self class], @selector(tsmd_applicationDidEnterBackground:), @selector(none_applicationDidEnterBackground:));
    Hook_Method([delegate class], @selector(applicationWillEnterForeground:), [self class], @selector(tsmd_applicationWillEnterForeground:), @selector(none_applicationWillEnterForeground:));
    Hook_Method([delegate class], @selector(applicationWillTerminate:), [self class], @selector(tsmd_applicationWillTerminate:), @selector(none_applicationWillTerminate:));
    Hook_Method([delegate class], @selector(applicationDidReceiveMemoryWarning:), [self class], @selector(tsmd_applicationDidReceiveMemoryWarning:), @selector(none_applicationDidReceiveMemoryWarning:));
    Hook_Method([delegate class], @selector(application:openURL:options:), [self class], @selector(tsmd_application:openURL:options:), @selector(none_application:openURL:options:));
    Hook_Method([delegate class], @selector(application:continueUserActivity:restorationHandler:), [self class],
                @selector(tsmd_application:continueUserActivity:restorationHandler:), @selector(none_application:continueUserActivity:restorationHandler:));
    [self hook_setDelegate:delegate];
}


// MARK: - hook UIApplication
/// App 已启动
- (BOOL)tsmd_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TSLog(@"hook didFinishLaunch：%@", launchOptions);
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    context.launchOptions = launchOptions;
    
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeDidFinishLaunchingEvent context:context];
    
    return [self tsmd_application:application didFinishLaunchingWithOptions:launchOptions];
}

/// App 已激活
- (void)tsmd_applicationDidBecomeActive:(UIApplication *)application {
    TSLog(@"hook applicationDidBecomeActive");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeDidBecomeActiveEvent context:context];
    
    [self tsmd_applicationDidBecomeActive:application];
}

/// App 即将变为非活动状态
- (void)tsmd_applicationWillResignActive:(UIApplication *)application {
    TSLog(@"hook willResignActive");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeWillResignActiveEvent context:context];
    
    [self tsmd_applicationWillResignActive:application];
}

/// App 现已进入后台
- (void)tsmd_applicationDidEnterBackground:(UIApplication *)application {
    TSLog(@"hook didEnterBackground");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeDidEnterBackgroundEvent context:context];
    
    [self tsmd_applicationDidEnterBackground:application];
}

/// App 即将进入前台
- (void)tsmd_applicationWillEnterForeground:(UIApplication *)application {
    TSLog(@"hook willEnterForeground");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeWillEnterForegroundEvent context:context];
    
    [self tsmd_applicationWillEnterForeground:application];
}

/// App 即将终止(结束)
- (void)tsmd_applicationWillTerminate:(UIApplication *)application {
    TSLog(@"hook willTerminate");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeWillTerminateEvent context:context];
    
    [self tsmd_applicationWillTerminate:application];
}

/// App 收到来自系统的内存警告，需要 app 清除无用内存。
- (void)tsmd_applicationDidReceiveMemoryWarning:(UIApplication *)application {
    TSLog(@"hook didReceiveMemoryWarning");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeDidReceiveMemoryWarningEvent context:context];
    
    [self tsmd_applicationDidReceiveMemoryWarning:application];
}

/// 打开由 URL 指定的资源，并提供启动可选的字典内容。
- (BOOL)tsmd_application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    TSLog(@"hook openURL options：%@", options);
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    context.openURL = url;
    context.openURLOptions = options;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeOpenURLEvent context:context];
    
    return [self tsmd_application:application openURL:url options:options];
}

/// 继续活动的数据是否可用
- (BOOL)tsmd_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    TSLog(@"hook continueUserActivity");
    
    JYAppEventContext *context = [[JYAppEventContext alloc] init];
    context.application = application;
    context.continueUserActivity = userActivity;
    context.continueUserActivityHandler = restorationHandler;
    [JYMediatorManager.shared triggerEvent:JYAppEventTypeContinueUserActivityEvent context:context];
    
    return [self tsmd_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}


// MARK: - 如果没有实现delegate方法，添加一个空方法
/// App 已启动
- (BOOL)none_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TSLog(@"hook none didFinishLaunch");
    return true;
}

/// App 已激活
- (void)none_applicationDidBecomeActive:(UIApplication *)application {
    TSLog(@"hook none didBecomeActive");
}

/// App 即将变为非活动状态
- (void)none_applicationWillResignActive:(UIApplication *)application {
    TSLog(@"hook none willResignActive");
}

/// App 现已进入后台
- (void)none_applicationDidEnterBackground:(UIApplication *)application {
    TSLog(@"hook none didEnterBackground");
}

/// App 即将进入前台
- (void)none_applicationWillEnterForeground:(UIApplication *)application {
    TSLog(@"hook none willEnterForeground");
}

/// App 即将终止(结束)
- (void)none_applicationWillTerminate:(UIApplication *)application {
    TSLog(@"hook none willTerminate");
}

/// App 收到来自系统的内存警告，需要 app 清除无用内存。
- (void)none_applicationDidReceiveMemoryWarning:(UIApplication *)application {
    TSLog(@"hook none didReceiveMemoryWarning");
}

/// 打开由 URL 指定的资源，并提供启动可选的字典内容。
- (BOOL)none_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    TSLog(@"hook none openURL");
    return true;
}

/// 继续活动的数据是否可用
- (BOOL)none_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    TSLog(@"hook none continueUserActivity");
    return true;
}

@end
