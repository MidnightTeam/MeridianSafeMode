
/*
 Thanks to @DGh0st on Discord for helping me set up this custom safe mode implementation :)
 */

@interface SBIconController : UIViewController
+ (instancetype)sharedInstance;
@end

@interface SBApplication : NSObject
@property (nonatomic, readonly) int pid;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)identifier;
@end

void showMeWhatYouGot() {
    UIViewController *controller = [%c(SBIconController) sharedInstance];
    
    NSString *safeModeMessage = [NSString stringWithFormat:@"You are now in safe mode. \n"
                                 "If this is unusual, just tap 'Respring'. \n"
                                 "If this has happened multiple times in a row, uninstall any new tweaks which may be causing this issue."];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Safe Mode" message:safeModeMessage preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *respringAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                        SBApplication *application = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.SpringBoard"];
                                        int pid = [application pid];
                                        kill(pid, 9);
                                    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:respringAction];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

%hook SBLockScreenViewController
- (void)finishUIUnlockFromSource:(int)source {
    %orig;
    showMeWhatYouGot();
}
%end

%hook SBDashBoardViewController
- (void)finishUIUnlockFromSource:(int)source {
    %orig;
    showMeWhatYouGot();
}
%end

%hook UIStatusBarTimeItemView
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2 {
    BOOL origValue = %orig;
    [self setValue:@"Exit Safe Mode" forKey:@"_timeString"];
    return origValue;
}
%end

%hook SpringBoard
- (void)handleStatusBarTapWithEvent:(id)arg1 {
    %orig;
    showMeWhatYouGot();
}
%end
