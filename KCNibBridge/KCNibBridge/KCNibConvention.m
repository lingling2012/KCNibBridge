//
//  KCNibConvention.m
//  KCNibBridge
//
//  Created by kitsion on 15/1/13.
//  Copyright (c) 2015年 kitsion. All rights reserved.
//

#import "KCNibConvention.h"

@implementation NSObject (KCNibConvention)

+ (NSString *)kc_nibID {
    return NSStringFromClass([self class]);
}

+ (UINib *)kc_nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end

@implementation UIView (KCNibConvention)

+ (id)kc_instantiateFromNib {
    return [self kc_instantiateFromNibInBundle:nil owner:nil];
}

+ (id)kc_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner {
    NSArray *views = [[self kc_nib] instantiateWithOwner:owner options:nil];
    for (UIView *view in views) {
        if ([view isMemberOfClass:[self class]]) {
            return view;
        }
    }
    NSAssert(NO, @"Expect file: %@", [NSString stringWithFormat:@"%@.xib", NSStringFromClass([self class])]);
    return nil;
}

@end

@implementation UIViewController (KCNibConvention)

+ (id)kc_instantiateFromStoryboardNamed:(NSString *)name {
    NSParameterAssert(name.length > 0);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    NSAssert(storyboard != nil, @"Expect file: %@", [NSString stringWithFormat:@"%@.storyboard", name]);
    if (!storyboard) {
        return nil;
    }
    id viewController = [storyboard instantiateViewControllerWithIdentifier:[self kc_nibID]];
    return viewController;
}

@end

@implementation NSObject (KCNibConventionDeprecated)

+ (id)kc_loadFromNib {
    return [self kc_loadFromNibWithOwner:nil];
}

+ (id)kc_loadFromNibWithOwner:(id)owner {
    NSArray *objects = [[self kc_nib] instantiateWithOwner:owner options:nil];
    for (UIView *obj in objects) {
        if ([obj isMemberOfClass:[self class]]) {
            return obj;
        }
    }
    return nil;
}

+ (id)kc_loadFromStoryboardNamed:(NSString *)name {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:[self kc_nibID]];
}


@end