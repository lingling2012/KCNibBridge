//
//  KCNibConvention.h
//  KCNibBridge
//
//  Created by kitsion on 15/1/13.
//  Copyright (c) 2015年 kitsion. All rights reserved.
//

@import UIKit;

@interface NSObject (KCNibConvention)

+ (NSString *)kc_nibID;

+ (UINib *)kc_nib;

@end

@interface UIView (KCNibConvention)

+ (id)kc_instantiateFromNib;

+ (id)kc_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner;

@end

@interface UIViewController (KCNibConvention)

+ (id)kc_instantiateFromStoryboardNamed:(NSString *)name;

@end

@interface NSObject (KCNibConventionDeprecated)

+ (id)kc_loadFromNib __attribute__((deprecated("Use + kc_instantiateFromNib instead")));

+ (id)kc_loadFromNibWithOwner:(id)owner __attribute__((deprecated("Use + kc_instantiateFromNibInBundle:owner: instead")));

+ (id)kc_loadFromStoryboardNamed:(NSString *)name __attribute__((deprecated("Use + kc_instantiateFromStoryboardNamed: instead")));

@end