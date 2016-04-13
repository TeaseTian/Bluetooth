//
//  MessageViewController.h
//  BluetoothDemo
//
//  Created by whatywhaty on 16/4/13.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueTooth.h"
@interface MessageViewController : UIViewController
@property(nonatomic,strong) BlueTooth *bluetooth;
@property(nonatomic,strong) NSString *UUID;
@end
