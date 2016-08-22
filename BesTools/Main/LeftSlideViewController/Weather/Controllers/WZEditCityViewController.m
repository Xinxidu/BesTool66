//
//  WZEditCityViewController.m
//  Weather
//
//  Created by 张武星 on 15/5/27.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZEditCityViewController.h"
#import "WZFileTool.h"

@interface WZEditCityViewController ()
@property(nonatomic,strong)UIBarButtonItem *leftButton;
@property(nonatomic,strong)UIBarButtonItem *rightButton;
@property(nonatomic,strong)NSMutableArray *citys;
@property(nonatomic,assign)BOOL isEditing;//编辑模式
@property(nonatomic,strong)NSMutableArray *checkStatus;//选中状态
@end

@implementation WZEditCityViewController

-(void)viewDidLoad {
    [self configureData];
    [self configureViews];
}

-(void)configureData{
    self.citys = [WZFileTool readCitysFromFile];
}

-(void)configureViews{
    self.leftButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    CGRect frame = [self.view bounds];
    self.tableView = [[UITableView alloc]initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.citys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.citys[indexPath.row];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
        return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.citys removeObjectAtIndex:indexPath.row];
    [WZFileTool writeCitysToFile:self.citys];
    [self configureData];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChangedNotification" object:nil];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.citys exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];

}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)rightButtonClicked{
    if (!self.isEditing) {
        [self.tableView setEditing:YES animated:YES];
        self.rightButton.title = @"确定";
        self.isEditing = YES;
        [self.tableView reloadData];
    }else{
        [self.tableView setEditing:NO animated:YES];
        self.rightButton.title = @"编辑";
        self.isEditing = NO;
        [self.tableView reloadData];
        [WZFileTool writeCitysToFile:self.citys];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChangedNotification" object:nil];
    }
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
