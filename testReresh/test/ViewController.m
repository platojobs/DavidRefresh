//
//  ViewController.m
//  test
//
//  Created by David on 18/06/21.
//  Copyright © 2018年 David. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LoadingView.h"
#import "UIScrollView+Davidfresh.h"
#define ANGLE(angle) ((M_PI*angle)/180)

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr=[NSMutableArray arrayWithCapacity:0];
    [self.dataArr addObjectsFromArray:@[@"123",@"234",@"239"]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64);
    }];
    __weak UITableView *weakTable = _tableview;
    [self.tableview addRefreshBlock:^(PanState state) {
        if (state == Pull) {
            //下拉
            if ([weakSelf.dataArr containsObject:@"21"]) {
                
            }else{
                [weakSelf.dataArr addObjectsFromArray:@[@"21",@"09"]];
                [weakTable reloadData];
            }
            NSLog(@"1111");
        }else if (state == Push) {
            //上拉
            NSLog(@"2222");
        }
        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakTable stopRefresh];
        });
        
    }];
}
-(UITableView*)tableview{
    if (!_tableview) {
        _tableview = [UITableView new];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc] init];
        _tableview.backgroundView.backgroundColor=[UIColor clearColor];
    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identify = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)dealloc {
    [_tableview removeRrefresh];
}

@end
