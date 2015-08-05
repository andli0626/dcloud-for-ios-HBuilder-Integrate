
//
//  PDRCore.h
//  Pandora
//
//  Created by Mac Pro on 12-12-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PDRCoreDefs.h"

@class PDRCoreAppWindow;
@interface PDRCoreWindowManager : UIView

- (void)addAppWindow:(PDRCoreAppWindow*)window;
- (void)removeAppWindow:(PDRCoreAppWindow*)window;

- (void)startLoadingPage;
- (void)endLoadingPage;
- (void)showIndicatorView;
- (void)hiddenIndicatorView;
//- (void)SetDebugRunMode:(BOOL)bDebug;

- (id)handleSysEvent:(PDRCoreSysEvent)evt withObject:(id)object;

@end