# Bluetooth
关于蓝牙4.0连接

1.搜索附近蓝牙设备
[self.bluetooth startScanDevicesWithInterval:5 CompleteBlock:^(NSArray *devices) {
        //做的相应的操作
    }];

2.连接设备
[self.bluetooth connectionWithDeviceUUID:[((CBPeripheral *)self.dataSource[indexPath.row]).identifier UUIDString] TimeOut:3 CompleteBlock:^(CBPeripheral *device, NSError *err) {
        if (device) {
            NSLog(@"查找设备的服务和特征...");
            //注册对应的收发数据的通知
        }else{
            NSLog(@"连接设备失败");
        }
        
    }];
