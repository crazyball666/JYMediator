//
//  JYMDHooker.h
//  JYMediator
//
//  Created by crazyball on 2023/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMDHooker : NSObject
+(void) hookClassMethod:(Class) originalClass
        originalSel:(SEL) originalSel
        replacedClass:(Class) replacedClass
        replacedSel:(SEL) replacedSel
                noneSel:(SEL) noneSel;

+(void) hookInstanceMethod:(Class) originalClass
        originalSel:(SEL) originalSel
        replacedClass:(Class) replacedClass
        replacedSel:(SEL) replacedSel
        noneSel:(SEL) noneSel;
@end
NS_ASSUME_NONNULL_END
