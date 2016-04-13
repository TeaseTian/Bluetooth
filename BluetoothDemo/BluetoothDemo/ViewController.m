//
//  ViewController.m
//  BluetoothDemo
//
//  Created by whatywhaty on 16/4/13.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import "ViewController.h"
#import "masonry.h"
#import "BlueTooth.h"
#import "MessageViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *deviceTable;

@property(strong,nonatomic) BlueTooth *bluetooth;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

//初始化数据
- (void)initData {
    self.bluetooth=[BlueTooth sharedInstance];
    self.dataSource=[[NSMutableArray alloc] init];
}
//初始化界面
- (void)initUI {
    self.deviceTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.deviceTable];
    self.deviceTable.dataSource = self;
    self.deviceTable.delegate = self;
    self.deviceTable.backgroundColor = [UIColor clearColor];
    [self.deviceTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-40);
    }];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:refreshBtn];
    refreshBtn.backgroundColor = [UIColor redColor];
    [refreshBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    refreshBtn.titleLabel.textColor = [UIColor blackColor];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceTable.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100.0f);
        make.height.mas_equalTo(40.0f);
    }];
}

#pragma mark 表格里面必须实现的方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.detailTextLabel.text=[((CBPeripheral *)self.dataSource[indexPath.row]).identifier UUIDString];
    cell.textLabel.text=((CBPeripheral *)self.dataSource[indexPath.row]).name;
    return cell;
}
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击之后取消高亮
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"连接设备中...");
    [self.bluetooth connectionWithDeviceUUID:[((CBPeripheral *)self.dataSource[indexPath.row]).identifier UUIDString] TimeOut:3 CompleteBlock:^(CBPeripheral *device, NSError *err) {
        if (device) {
            NSLog(@"查找设备的服务和特征...");
            [self.bluetooth discoverServiceAndCharacteristicWithInterval:3 CompleteBlock:^(NSArray *serviceArray, NSArray *characteristicArray, NSError *err) {
                
                NSLog(@"查找服务和特征成功 %ld",serviceArray.count);
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MessageViewController *msgVC = [storyBoard instantiateViewControllerWithIdentifier:@"MsgViewController"];
                msgVC.bluetooth=self.bluetooth;
                msgVC.UUID=[((CBPeripheral *)self.dataSource[indexPath.row]).identifier UUIDString];
                [self presentViewController:msgVC animated:YES completion:nil];
            }];
        }else{
            NSLog(@"连接设备失败");
        }
        
    }];
}

-(void)refreshBtnClick:(UIButton *)btn
{
    __weak typeof(self) WeakSelf=self;
    [self.bluetooth startScanDevicesWithInterval:5 CompleteBlock:^(NSArray *devices) {
        [WeakSelf.dataSource removeAllObjects];
        for (CBPeripheral *per in devices) {
            [WeakSelf.dataSource addObject:per];
        }
        [WeakSelf.deviceTable reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
