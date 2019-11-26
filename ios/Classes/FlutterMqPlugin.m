#import "FlutterMqPlugin.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import <MQChatViewManager.h>


@interface FlutterMqPlugin()
@property(nonatomic, strong) FlutterMethodChannel *channel;
@end


@implementation FlutterMqPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel
{
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_mq"
            binaryMessenger:[registrar messenger]];
  FlutterMqPlugin* instance = [[FlutterMqPlugin alloc] initWithChannel:channel];

  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if([@"initMeiQia" isEqualToString:call.method]){
      //初始化美洽
      [self initMeiQia:call.arguments[@"appKey"] result:result];
  }
  else if([@"openMeiQia" isEqualToString:call.method]){
      //调用美洽
      [self openMeiQiaChat:call];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}
#pragma mark  集成第一步: 初始化,  参数:appkey  ,尽可能早的初始化appkey.
- (void)initMeiQia:(NSString *) appKey result:(FlutterResult)result{
    [MQManager initWithAppkey:appKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
            result(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
            result(@"美洽 SDK：初始化失败");
        }
    }];
}

bool isUpdate = false;

- (void)openMeiQiaChat:(FlutterMethodCall *)call {
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    if (call.arguments) {
        if (call.arguments[@"userInfo"]) {
            if (call.arguments[@"isUpdate"]) {
                //override 是否强制更新，如果不设置此值为 YES，设置只有第一次有效。
                [chatViewManager setClientInfo:call.arguments[@"userInfo"]override:(YES)];
            }else{
                [chatViewManager setClientInfo:call.arguments[@"userInfo"]];
            }
//            if (isUpdate) {
//                //override 是否强制更新，如果不设置此值为 YES，设置只有第一次有效。
//                [chatViewManager setClientInfo:call.arguments[@"userInfo"]override:(YES)];
//            }else{
//                isUpdate = true;
//                [chatViewManager setClientInfo:call.arguments[@"userInfo"]];
//            }
        }
        if (call.arguments[@"id"]) {
            [chatViewManager setLoginCustomizedId:call.arguments[@"id"]];
        }
    }
    [chatViewManager enableEventDispaly:(true)];
    [chatViewManager enableSyncServerMessage:(true)];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    [chatViewManager pushMQChatViewControllerInViewController:viewController];
}
@end
