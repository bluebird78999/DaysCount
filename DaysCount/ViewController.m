//
//  ViewController.m
//  DaysCount
//
//  Created by LiuHongfeng on 16/01/2017.
//  Copyright © 2017 LiuHongfeng. All rights reserved.
//

#import "ViewController.h"
#import "MiniBrowser.h"

#define screenSize [UIScreen mainScreen].bounds.size
#define key_log @"key_log"
#define height_logView (screenSize.height - 50)

@interface ViewController ()
{
    UILabel *_headLabel1;
    UILabel *_headLabel2;
    UILabel *_daysCountLabel;
    UILabel *_weeksCountLabel;
    UILabel *_myTextLabel1;
    UILabel *_myTextLabel2;
    UITextView *_logShowView;
    MiniBrowser *_miniBrowser;
    UIButton *_closeButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch.jpg"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    float x = 20;
    float y = 50;
    float lineHeight = 40;
    _headLabel1 = [self creatLabelWithFrame:CGRectMake(x, y, screenSize.width, 30)];
    _headLabel2 = [self creatLabelWithFrame:CGRectMake(x, y + lineHeight * 1, screenSize.width, 30)];
    _daysCountLabel = [self creatLabelWithFrame:CGRectMake(x, y + lineHeight * 2, screenSize.width, 30)];
     _weeksCountLabel = [self creatLabelWithFrame:CGRectMake(x, y + lineHeight * 3, screenSize.width, 30)];
    _myTextLabel1 = [self creatLabelWithFrame:CGRectMake(x, y + lineHeight * 4, screenSize.width, 30)];
    _myTextLabel2 = [self creatLabelWithFrame:CGRectMake(x, y + lineHeight * 5, screenSize.width, 30)];
    [self setIconBadgeNumberWithApplication:[UIApplication sharedApplication]];
    
    //左下角按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, screenSize.height - 50, 50, 50)];
    [self.view addSubview:leftButton];
    [leftButton addTarget:self action:@selector(showOpenLogs:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    //右下角按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width - 150, screenSize.height - 40, 150, 50)];
    [self.view addSubview:rightButton];
    [rightButton addTarget:self action:@selector(showWeb:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitle:@"开心一刻😜😂" forState:UIControlStateNormal];

    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width - 50, _logShowView.frame.origin.y, 50, 50)];
    [_closeButton setBackgroundColor:[UIColor grayColor]];
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOpenEvent) name:@"applicationDidBecomeActive" object:nil];
}

- (UILabel *)creatLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    return label;
}
- (void)setIconBadgeNumberWithApplication:(UIApplication *)application
{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDate *date =[dateFormatter dateFromString:@"2016-11-04 00:00:00"];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:today options:0];
    NSInteger days = [comps day];
    NSLog(@"days count===%@",@(days));
    application.applicationIconBadgeNumber = days;
    //local push
    /*
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"加油，亲爱的!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"现在是：%@ 今天是第 %ld 天!",[dateFormatter stringFromDate:today],(days)]
                                                         arguments:nil];
    content.sound = [UNNotificationSound soundNamed:@"sound.wav"];
    content.badge = @(days);
    application.applicationIconBadgeNumber = days;
    // Configure the trigger for a 8am push.
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = 8;
    dateComponents.minute = 0;
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
                                              triggerWithDateMatchingComponents:dateComponents repeats:YES];
    
    // Create the request object.
    UNNotificationRequest* request = [UNNotificationRequest
                                      requestWithIdentifier:@"MorningAlarm" content:content trigger:trigger];
    
    UNUserNotificationCenter* notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    notificationCenter.delegate = self;
    [notificationCenter removeAllDeliveredNotifications];
    [notificationCenter removeAllPendingNotificationRequests];
    [notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    */
    _headLabel1.text = @"亲爱的，";
    _headLabel2.text = @"从2016.11.04算起，";
    
    NSString *dayStr = [NSString stringWithFormat:@"%@",@(days)];
    NSMutableAttributedString *daysCountString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"到今天总共是%@天，",dayStr]];
    NSDictionary * countAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName:[UIColor greenColor],};
    [daysCountString setAttributes:countAttributes range:NSMakeRange(6,dayStr.length)];
    _daysCountLabel.attributedText = daysCountString;

    NSInteger weeks = days/7;
    NSInteger daysLessOneWeek = days % 7;
    NSString *weeksStr = [NSString stringWithFormat:@"%@",@(weeks)];
    if (daysLessOneWeek == 0) {
        NSMutableAttributedString *weeksCountString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今天正好是第%@周整。",weeksStr]];
        NSDictionary * countAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName:[UIColor greenColor],};
        [weeksCountString setAttributes:countAttributes range:NSMakeRange(6,weeksStr.length)];
        _weeksCountLabel.attributedText = weeksCountString;
    }else{
        NSMutableAttributedString *weeksCountString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"也就是第%@周零%@天。",weeksStr,@(daysLessOneWeek)]];
        NSDictionary * countAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName:[UIColor greenColor],};
        [weeksCountString setAttributes:countAttributes range:NSMakeRange(4,weeksStr.length)];
        [weeksCountString setAttributes:countAttributes range:NSMakeRange(weeksCountString.length - 3,1)];
        _weeksCountLabel.attributedText = weeksCountString;
    }
    _myTextLabel1.text = @"老婆，辛苦啦，继续加油！";
    _myTextLabel2.text = @"老公与你一起期待小生命的到来！";
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    completionHandler();
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDate *date =[dateFormatter dateFromString:@"2016-11-04 00:00:00"];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:today options:0];
    NSInteger days = [comps day];
    [UIApplication sharedApplication].applicationIconBadgeNumber = days;

}

- (void)logOpenEvent
{
    NSArray *logs = [[NSUserDefaults standardUserDefaults] arrayForKey:key_log];
    NSMutableArray *newLogs = [NSMutableArray arrayWithArray:logs];
    NSDate *now=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [newLogs addObject:[dateFormatter stringFromDate:now]];
    [[NSUserDefaults standardUserDefaults] setObject:newLogs forKey:key_log];
}

- (void)showOpenLogs:(UIButton *)button
{
    NSArray *logs = [[NSUserDefaults standardUserDefaults] arrayForKey:key_log];
    NSString *logStr = @"";
    if (logs.count > 0) {
            for (NSString *log in logs) {
                logStr = [logStr stringByAppendingString:[NSString stringWithFormat:@"%@,\n",log]];
        }
    }
    //log view
    if (!_logShowView) {
        _logShowView = [[UITextView alloc] initWithFrame:CGRectMake(0, screenSize.height - height_logView, screenSize.width, height_logView)];
    }
    _logShowView.text = logStr;
    [self.view addSubview:_logShowView];
    [self.view addSubview:_closeButton];
    [_closeButton addTarget:self action:@selector(closeLogsView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeLogsView
{
    [_logShowView removeFromSuperview];
    [_closeButton removeFromSuperview];
}

- (void)showWeb:(UIButton *)button
{
    //web view
    if (!_miniBrowser) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsAirPlayForMediaPlayback = YES;
        _miniBrowser = [[MiniBrowser alloc] initBrowserWithFrame: CGRectMake(0, screenSize.height - height_logView, screenSize.width, height_logView) configuration:configuration];
    }
    [self.view addSubview:_miniBrowser.browserView];
    [_miniBrowser loadURLString:@"https://m.weibo.cn/u/5789140445"];
    [self.view addSubview:_closeButton];
    [_closeButton addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeWebView
{
    [_miniBrowser.browserView removeFromSuperview];
    [_closeButton removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
