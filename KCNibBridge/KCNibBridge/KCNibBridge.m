//
//  KCNibBridge.m
//  KCNibBridge
//
//  Created by kitsion on 15/1/13.
//  Copyright (c) 2015年 kitsion. All rights reserved.
//

#import "KCNibBridge.h"

@import ObjectiveC;

static UIView * KCNibBridgeCreateRealViewFromPlaceholderView(UIView *placeholderView) {
    
    UIView *realView = [[placeholderView class] kc_loadFromNibWithOwner:nil];
    realView.frame = placeholderView.frame;
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.hidden = placeholderView.hidden;
    realView.tag = placeholderView.tag;
    
    if (placeholderView.constraints.count > 0) {
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            NSLayoutConstraint *newConstraint;
            
            if (!constraint.secondItem) {
                newConstraint = [NSLayoutConstraint constraintWithItem:realView
                                                             attribute:constraint.firstAttribute
                                                             relatedBy:constraint.relation
                                                                toItem:nil
                                                             attribute:constraint.secondAttribute
                                                            multiplier:constraint.multiplier
                                                              constant:constraint.constant];
            } else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint = [NSLayoutConstraint constraintWithItem:realView
                                                             attribute:constraint.firstAttribute
                                                             relatedBy:constraint.relation
                                                                toItem:realView
                                                             attribute:constraint.secondAttribute
                                                            multiplier:constraint.multiplier
                                                              constant:constraint.constant];
            }
            
            newConstraint.shouldBeArchived = constraint.shouldBeArchived;
            newConstraint.priority = constraint.priority;
            [realView addConstraint:newConstraint];
        }
    }
    return realView;
}

__attribute__((constructor)) static void KCNibBridgeHackAwakeAfterUsingCoder () {
    static NSMutableDictionary *placeholderMapping = nil;
    placeholderMapping = [NSMutableDictionary dictionary];
    
    BOOL (^isRealView)(UIView *) = ^BOOL (UIView *view) {
        return [placeholderMapping[NSStringFromClass(view.class)] boolValue];
    };
    
    void (^setIsRealView)(UIView *, BOOL) = ^(UIView *view, BOOL isPlaceholder) {
        placeholderMapping[NSStringFromClass(view.class)] = @(isPlaceholder);
    };
    
    id (^newIMPBlock)(id, NSCoder *) = ^id (UIView *self, NSCoder *decoder) {
        if (![[self class] conformsToProtocol:@protocol(KCNibBridge)]) {
            if ([(id)[self class] respondsToSelector:@selector(kc_shouldApplyNibBridging)]) {
                BOOL should = [[self class] kc_shouldApplyNibBridging];
                if (!should) {
                    return self;
                }
            }
        }
        
        if (!isRealView(self)) {
            setIsRealView(self, YES);
            UIView *realView = KCNibBridgeCreateRealViewFromPlaceholderView(self);
            return realView;
        }
        
        setIsRealView(self, NO);
        
        return self;
    };
    
    SEL selector = sel_registerName("awakeAfterUsingCoder:");
    Method method = class_getInstanceMethod([UIView class], selector);
    const char *typeEncoding = method_getTypeEncoding(method);
    IMP newIMP = imp_implementationWithBlock(newIMPBlock);
    class_addMethod([UIView class], selector, newIMP, typeEncoding);
}

@implementation UIView (KCNibConventionDeprecated)

+ (BOOL)kc_shouldApplyNibBridging {
    return NO;
}

@end