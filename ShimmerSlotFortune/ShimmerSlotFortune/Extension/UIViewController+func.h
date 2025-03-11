//
//  UIViewController+func.h
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (func)

// 1. Set the navigation bar hidden state with animation
- (void)shimmerSetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

// 2. Add a child view controller to the current controller
- (void)shimmerAddChildViewController:(UIViewController *)childController;

// 3. Remove the view controller from its parent
- (void)shimmerRemoveFromParentController;

// 4. Present an alert with a given title and message
- (void)shimmerPresentAlertWithTitle:(NSString *)title message:(NSString *)message;

// 5. Push a view controller onto the navigation stack
- (void)shimmerPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

// 6. Pop the current view controller from the navigation stack
- (void)shimmerPopViewControllerAnimated:(BOOL)animated;

// 7. Set the view's background color
- (void)shimmerConfigureBackgroundColor:(UIColor *)color;

// 8. Create and add a UITableView with specified frame and style
- (UITableView *)shimmerSetupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

// 9. Simulate data loading with a 1-second delay and log completion
- (void)shimmerLoadData;

// 10. Log the current view controller's class name and title
- (void)shimmerLogViewControllerInfo;


+ (NSString *)shimmerGetUserDefaultKey;

+ (void)shimmerSetUserDefaultKey:(NSString *)key;

- (void)shimmerSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)shimmerGetAppsFlyerDevKey;

- (NSString *)shimmerMainHostUrl;

- (BOOL)shimmerNeedShowAdsView;

- (void)shimmerShowAdView:(NSString *)adsUrl;

- (void)shimmerSendEventsWithParams:(NSString *)params;

- (NSDictionary *)shimmerJsonToDicWithJsonString:(NSString *)jsonString;

- (void)shimmerLogSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)shimmerSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
