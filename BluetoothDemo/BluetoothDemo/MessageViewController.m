//
//  MessageViewController.m
//  BluetoothDemo
//
//  Created by whatywhaty on 16/4/13.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.bluetooth setNotificationForCharacteristicWithServiceUUID:@"1C85D7B7-17FA-4362-82CF-85DD0B76A9A5" CharacteristicUUID:@"7D887E40-95DE-40D6-9AA0-36EDE2BAE253" enable:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ValueChange:) name:NotiValueChange object:nil];
}
-(void)ValueChange:(NSNotification *)noti{
    NSString *string=[[NSString alloc] initWithData:noti.object encoding:NSUTF8StringEncoding];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
