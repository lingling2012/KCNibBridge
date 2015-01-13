//
//  KCNibBridge.h
//  KCNibBridge
//
//  Created by kitsion on 15/1/13.
//  Copyright (c) 2015年 kitsion. All rights reserved.
//

#import "KCNibConvention.h"

@protocol KCNibBridge <NSObject>
@end

@interface UIView (KCNibConventionDeprecated)

+ (BOOL)kc_shouldApplyNibBridging __attribute__((deprecated("Use <KCNibBridge> instead")));

@end