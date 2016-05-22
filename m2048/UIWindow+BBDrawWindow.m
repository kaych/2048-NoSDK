//
//  BBSDK+CALayer.m
//  BuddyBuildSDK
//
//  Created by Veronica Baldys on 2016-05-16.
//  Copyright © 2016 BB. All rights reserved.
//


#import "UIWindow+BBDrawWindow.h"

void loadAppCategory() {
    NSLog(@"Loading Application");
}

@implementation CALayer (BBTouchWindow)

//- (MBFingerTipWindow*) bbTouchWindow {
//    static MBFingerTipWindow *window = nil;
//
//    L(@"UIAPPLICATION CATEGORY INITIALIZE MBFINGERTIPWINDOW");
//
//
//    if (!window) {
//
//        window = [[MBFingerTipWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    }
//    return window;
//}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];


        SEL originalSelector = @selector(drawInContext:);
        SEL swizzledSelector = @selector(xxx_drawInContext:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}



#pragma mark - Method Swizzling

- (void)xxx_drawInContext:(CGContextRef)ctx {
    [self xxx_drawInContext:ctx];
    NSLog(@"Something %@", ctx);

     NSLog(@"Break");
}

@end
