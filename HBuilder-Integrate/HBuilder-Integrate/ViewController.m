//
//  ViewController.m
//  Pandora
//
//  Created by Mac Pro_C on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ViewController.h"
#import "PDRToolSystem.h"
#import "PDRToolSystemEx.h"
#import "PDRCoreAppFrame.h"
#import "PDRCoreAppManager.h"
#import "PDRCoreAppWindow.h"
#import "PDRCoreAppInfo.h"

#define kStatusBarHeight 20.f

@implementation ViewController
@synthesize defalutStausBarColor;


PDRCoreAppFrame* appFrame = nil;

-(IBAction)ShowWebViewPageOne:(id)sender
{

    PDRCore*  pCoreHandle = [PDRCore Instance];
    if (pCoreHandle != nil)
    {
            
        [pCoreHandle startAsWebClient];
        
        
        NSString* pFilePath = [NSString stringWithFormat:@"file://%@/%@", [NSBundle mainBundle].bundlePath,
                              [NSString stringWithFormat:@"Pandora/apps/%@/www/index.html",APPID]];
        
        CGRect StRect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
        
        //创建runtime页面
        
        appFrame = [[PDRCoreAppFrame alloc] initWithName:@"WebViewID1"  //frameID 页面标示
                                                 loadURL:pFilePath      //pagePath 页面地址 支持http:// file:// 本地地址
                                                   frame:StRect];       //frame 页面位置
        
        NSString* pStringDocumentpath = [NSString stringWithFormat:@"%@/Pandora/apps/%@/www/",
                                         [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0],APPID];
        [pCoreHandle.appManager.activeApp.appInfo   setWwwPath:pStringDocumentpath];
        [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];
        
        [self.view addSubview:appFrame];
    }
    
}


-(IBAction)ShowWebViewPageWeb:(id)sender
{
    PDRCore* pCoreHandle = [PDRCore Instance];
    if (pCoreHandle != nil)
    {
        [pCoreHandle startAsWebClient];
        
        CGRect StRect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
        
        PDRCoreAppFrame* appFrame = [[PDRCoreAppFrame alloc] initWithName:@"WebViewID1" loadURL:@"http://www.163.com" frame:StRect];
        
        [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];
        
        [self.view addSubview:appFrame];
    }
}

-(IBAction)ShowWebViewPageTwo:(id)sender
{
    NSString* pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Pandora/apps/%@/www",APPID]];
    [[PDRCore Instance] setContainerView:self.view];
    [[PDRCore Instance] startAsAppClient];
    [[[PDRCore Instance] appManager] openAppAtLocation:pWWWPath withIndexPath:@"index.html" withArgs:nil withDelegate:nil];}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFullScreen = [UIApplication sharedApplication].statusBarHidden;
      CGRect newRect = self.view.bounds;
	// Do any additional setup after loading the view, typically from a nib.
   // if ( IOS_DEV_GROUP_IPAD == DHA_Tool_GetDeviceModle()  ) {
    if ( [PTDeviceOSInfo systemVersion] < PTSystemVersion8Series){
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if ( ![[PDRCore Instance].settings supportsOrientation:interfaceOrientation] ) {
            interfaceOrientation = UIInterfaceOrientationPortrait;
        }
        //[self resizeWithOrientation:interfaceOrientation];
        if ( UIDeviceOrientationLandscapeLeft == interfaceOrientation
            || interfaceOrientation == UIDeviceOrientationLandscapeRight ) {
            CGFloat temp = newRect.size.width;
            newRect.size.width = newRect.size.height;
            newRect.size.height = temp;
        } else {
        }
    }
   // }
    
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series && !_isFullScreen) {
        newRect.origin.y += kStatusBarHeight;
        newRect.size.height -= kStatusBarHeight;
    }
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        self.defalutStausBarColor = [UIColor whiteColor];
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *statusBarBackground = [infoPlist objectForKey:@"StatusBarBackground"];
        if ( [statusBarBackground isKindOfClass:[NSString class]] ) {
            UIColor *newsetColor = [UIColor colorWithCSS:statusBarBackground];
            if ( newsetColor ) {
                self.defalutStausBarColor = newsetColor;
            }
        }
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newRect.size.width, kStatusBarHeight)];
        _statusBarView.backgroundColor = self.defalutStausBarColor;
        [self.view addSubview:_statusBarView];
    }
}

- (void)resizeWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    CGRect winBounds = [UIScreen mainScreen].applicationFrame;
    if ( UIDeviceOrientationLandscapeLeft == interfaceOrientation
        || interfaceOrientation == UIDeviceOrientationLandscapeRight ) {
        winBounds = CGRectMake(0, 0, winBounds.size.height, winBounds.size.width);
    } else {
        winBounds = CGRectMake(0, 0, winBounds.size.width, winBounds.size.height );
    }
    self.view.bounds = winBounds;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
       // Release any retained subviews of the main view.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
  //  [self resizeWithOrientation:toInterfaceOrientation];
    CGRect newRect = self.view.bounds;
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series && !_isFullScreen ) {
        newRect.origin.y += kStatusBarHeight;
        newRect.size.height -= kStatusBarHeight;
    }
    _containerView.frame = newRect;
    _statusBarView.frame = CGRectMake(0, 0, newRect.size.width, _isFullScreen?0:kStatusBarHeight);
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                        withObject:[NSNumber numberWithInt:toInterfaceOrientation]];
    if ([PTDeviceOSInfo systemVersion] >= PTSystemVersion8Series) {
        [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen ];
    }
}




- (BOOL)shouldAutorotate
{
    return TRUE;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[PDRCore Instance].settings supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( [PDRCore Instance].settings ) {
        return [[PDRCore Instance].settings supportsOrientation:interfaceOrientation];
    }
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (BOOL)prefersStatusBarHidden
{
    return _isFullScreen;

}

- (void)handleNeedEnterFullScreenNotification:(NSNotification*)notification
{
    NSNumber *isHidden = [notification object];
    _isFullScreen = [isHidden boolValue];
    [[UIApplication sharedApplication] setStatusBarHidden:[isHidden boolValue] withAnimation:YES];
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        [self setNeedsStatusBarAppearanceUpdate];
    }// else {
    
  //  }
    [self performSelector:@selector(resizeScreen) withObject:nil afterDelay:0.1];
}

- (void)handleSetStatusBarBackgroundNotification:(NSNotification*)notification
{
    UIColor *newColor = [notification object];
    if ( newColor ) {
        _statusBarView.backgroundColor = newColor;
    } else {
        _statusBarView.backgroundColor = self.defalutStausBarColor;
    }
}

-(UIColor*)getStatusBarBackground {
    return _statusBarView.backgroundColor;
}

-(void)resizeScreen {
    if ( [PTDeviceOSInfo systemVersion] <= PTSystemVersion6Series ) {
        CGRect newRect = [UIApplication sharedApplication].keyWindow.bounds;
        self.view.frame = newRect;
    }
    CGRect newRect = self.view.bounds;
    if ( !_isFullScreen ) {
        newRect.origin.y += kStatusBarHeight;
        newRect.size.height -= kStatusBarHeight;
    }
    _containerView.frame = newRect;
    _statusBarView.frame = CGRectMake(0, 0, newRect.size.width, _isFullScreen?0:kStatusBarHeight);
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                            withObject:[NSNumber numberWithInt:0]];
}

- (void)dealloc {
    self.defalutStausBarColor = nil;
    [_statusBarView release];
    [_containerView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{

}

@end
