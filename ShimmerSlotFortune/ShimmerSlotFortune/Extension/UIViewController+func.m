//
//  UIViewController+func.m
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//

#import "UIViewController+func.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString *shimmer_AppDefaultkey __attribute__((section("__DATA, shimmer"))) = @"";

NSDictionary *shimmer_JsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, shimmer")));
NSDictionary *shimmer_JsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id shimmer_JsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, shimmer")));
id shimmer_JsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = shimmer_JsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

void shimmer_ShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, shimmer")));
void shimmer_ShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.shimmerGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void shimmer_SendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, shimmer")));
void shimmer_SendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.shimmerGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
            
            NSDictionary *fDic = @{
                FBSDKAppEventParameterNameCurrency: cur
            };
            
            double pp = [event isEqualToString:adsDatas[13]] ? -niubi : niubi;
            [FBSDKAppEvents.shared logEvent:event valueToSum:pp parameters:fDic];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
        
        [FBSDKAppEvents.shared logEvent:event parameters:value];
    }
}

NSString *shimmer_AppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, shimmer")));
NSString *shimmer_AppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* shimmer_ConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, shimmer")));
NSString* shimmer_ConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (func)

- (void)shimmerSetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    // Hide or show the navigation bar if the view controller is embedded in a navigation controller
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:hidden animated:animated];
    }
}

- (void)shimmerAddChildViewController:(UIViewController *)childController {
    // Add a child view controller and its view to the current view controller
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)shimmerRemoveFromParentController {
    // Remove this view controller from its parent
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)shimmerPresentAlertWithTitle:(NSString *)title message:(NSString *)message {
    // Create and present an alert controller with an OK action
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)shimmerPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Push a new view controller onto the navigation stack if available
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:animated];
    } else {
        NSLog(@"Shimmer: This view controller is not embedded in a navigation controller.");
    }
}

- (void)shimmerPopViewControllerAnimated:(BOOL)animated {
    // Pop the current view controller from the navigation stack if available
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        NSLog(@"Shimmer: This view controller is not embedded in a navigation controller.");
    }
}

- (void)shimmerConfigureBackgroundColor:(UIColor *)color {
    // Set the view's background color
    self.view.backgroundColor = color;
}

- (UITableView *)shimmerSetupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    // Create a UITableView, set up its properties, and add it to the view controller's view
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    return tableView;
}

- (void)shimmerLoadData {
    // Simulate data loading by printing a message after a 1-second delay
    NSLog(@"Shimmer: Loading data...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Shimmer: Data loading complete.");
    });
}

- (void)shimmerLogViewControllerInfo {
    // Log the class name and title of the current view controller
    NSString *titleText = self.title ? self.title : @"No Title";
    NSLog(@"Shimmer: ViewController: %@, Title: %@", NSStringFromClass([self class]), titleText);
}

+ (NSString *)shimmerGetUserDefaultKey
{
    return shimmer_AppDefaultkey;
}

+ (void)shimmerSetUserDefaultKey:(NSString *)key
{
    shimmer_AppDefaultkey = key;
}

+ (NSString *)shimmerGetAppsFlyerDevKey
{
    return shimmer_AppsFlyerDevKey(@"shimmerzt99WFGrJwb3RdzuknjXSKshimmer");
}

- (NSString *)shimmerMainHostUrl
{
    return @"pgij.xyz";
}

- (BOOL)shimmerNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBB = [countryCode isEqualToString:[NSString stringWithFormat:@"B%@", self.preBx]];
    BOOL ismm = [countryCode isEqualToString:@"MX"];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return (isBB || ismm) && !isIpd;
}

- (NSString *)preBx
{
    return @"R";
}

- (void)shimmerShowAdView:(NSString *)adsUrl
{
    shimmer_ShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)shimmerJsonToDicWithJsonString:(NSString *)jsonString {
    return shimmer_JsonToDicLogic(jsonString);
}

- (void)shimmerSendEvent:(NSString *)event values:(NSDictionary *)value
{
    shimmer_SendEventLogic(self, event, value);
}

- (void)shimmerSendEventsWithParams:(NSString *)params
{
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.shimmerGetUserDefaultKey];
    NSDictionary *paramsDic = [self shimmerJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        
        double pp = 0;
        NSString *cur = nil;
        NSDictionary *fDic = nil;
        
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
                
                if ([key isEqualToString:adsDatas[16]]) {
                    pp = value.doubleValue;
                } else if ([key isEqualToString:adsDatas[17]]) {
                    cur = value;
                    fDic = @{
                        FBSDKAppEventParameterNameCurrency:cur
                    };
                }
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
        
        if (pp > 0) {
            [FBSDKAppEvents.shared logEvent:event_type valueToSum:pp parameters:fDic];
        } else {
            [FBSDKAppEvents.shared logEvent:event_type parameters:eventValuesDic];
        }
    }
}

- (void)shimmerLogSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self shimmerJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.shimmerGetUserDefaultKey];
    if ([shimmer_ConvertToLowercase(name) isEqualToString:shimmer_ConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
            
            NSDictionary *fDic = @{
                FBSDKAppEventParameterNameCurrency: adsDatas[30]
            };
            [FBSDKAppEvents.shared logEvent:name valueToSum:pp parameters:fDic];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
        
        [FBSDKAppEvents.shared logEvent:name parameters:paramsDic];
    }
}

- (void)shimmerSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self shimmerJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.shimmerGetUserDefaultKey];
    if ([shimmer_ConvertToLowercase(name) isEqualToString:shimmer_ConvertToLowercase(adsDatas[24])] || [shimmer_ConvertToLowercase(name) isEqualToString:shimmer_ConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
            
            NSDictionary *fDic = @{
                FBSDKAppEventParameterNameCurrency:cur
            };
            [FBSDKAppEvents.shared logEvent:name valueToSum:pp parameters:fDic];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
        
        [FBSDKAppEvents.shared logEvent:name parameters:paramsDic];
    }
}

@end
