//
//  ViewController.m
//  MyTableView
//
//  Created by iSongWei on 2017/4/25.
//  Copyright © 2017年 iSong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) IBOutlet UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * isshow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _tableView.rowHeight = 50;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self createDataSource];
    [self createNavigationItem];
}
-(void)createDataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }else{
        [_dataSource removeAllObjects];
    }
    _isshow = [NSMutableArray array];
    NSArray * plistPaths = [[NSBundle mainBundle]pathsForResourcesOfType:@"plist" inDirectory:nil];
    for (NSString * path in plistPaths) {
        if ([path rangeOfString:@"image_"].location == NSNotFound) {
            continue;
        }
        NSArray * arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray * mulArray = [NSMutableArray arrayWithArray:arr];
        [_dataSource addObject:mulArray];
        [_isshow addObject:@YES];
    }
}
#pragma mark - ===============Nav===============

-(void)createNavigationItem{
    
    UIBarButtonItem * left1 = [[UIBarButtonItem alloc]initWithTitle:@"多选编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(navItemClicked:)];
    left1.tag = 51;
    self.navigationItem.leftBarButtonItems = @[left1];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"单选编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(navItemClicked:)];
    rightItem.tag = 61;
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)navItemClicked:(UIBarButtonItem *)item{
    if (item.tag == 51) {
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        if (_tableView.editing == NO) {
            UIBarButtonItem * item2 = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:(UIBarButtonItemStylePlain) target:self action:@selector (deleteClicked)];
            item.title = @"完成";
            self.navigationItem.leftBarButtonItems = @[item,item2];
            [_tableView setEditing:YES animated:YES];
        }else{
            item.title = @"多选编辑";
            self.navigationItem.leftBarButtonItems = @[item];
            _tableView.allowsMultipleSelectionDuringEditing = NO;
            [_tableView setEditing:NO animated:YES];
        }
    }
    
    if (item.tag == 61) {
        if (_tableView.editing == NO) {
            item.title = @"完成";
            [_tableView setEditing:YES animated:YES];
        }else{
            item.title = @"单选编辑";
            [_tableView setEditing:NO animated:YES];
        }
    }
}
#pragma mark - ===============UITableView===============

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_isshow[section] boolValue]) {
        return [_dataSource[section] count];
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString * imageName = _dataSource[indexPath.section][indexPath.row][@"imageName"];
    cell.textLabel.text = imageName;
    NSArray * nameAndType = [imageName componentsSeparatedByString:@"."];
    NSString * imagePath = [[NSBundle mainBundle]pathForResource:nameAndType[0] ofType:[nameAndType  lastObject]];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = image;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * arr = @[@"圣斗士",@"海贼",@"火影",@"美女"];
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor redColor];
    label.userInteractionEnabled = YES;
    label.text = arr[section];
    label.tag = 1000+section;
    //添加手势
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [label addGestureRecognizer:tgr];
    return label;
    
}
#pragma mark - ===============折叠===============
-(void)tapped:(UITapGestureRecognizer*)tap{
    //获取分组下标
    NSInteger section = tap.view.tag - 1000;
    BOOL isshow = [_isshow[section] boolValue];
    
    
    if (isshow == YES) {
        //改变为收起状态
        [_isshow replaceObjectAtIndex:section withObject:@NO];
    }else{
        //收起改为展开
        [_isshow replaceObjectAtIndex:section withObject:@YES];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationFade)];
    
}

#pragma mark - ===============顺序调节===============


-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //对数据源进行相应调节
    NSMutableArray * srcArr = _dataSource[sourceIndexPath.section];
    id obj = srcArr[sourceIndexPath.row];
    [srcArr removeObjectAtIndex:sourceIndexPath.row];
    //插入到目的位置
    NSMutableArray * dstArr = _dataSource[destinationIndexPath.section];
    [dstArr insertObject:obj atIndex:destinationIndexPath.row];
    
}
#pragma mark - ===============左划删除===============


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 从数据源中删除
        [_dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
        // 从列表中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        NSMutableArray * arr  = _dataSource[indexPath.section];
        [arr insertObject:@{@"imageInfo":@"插入的图片",@"imageName":@"美女01.jpg"} atIndex:indexPath.row];
        //插入一个个cell
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
}
//实现了该方法  会将系统自带的给覆盖掉
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删了" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"删除了%lu组 %lu行",indexPath.section,indexPath.row);
//        // 从数据源中删除
//        [_dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
//        // 从列表中删除
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }];
//
//    UITableViewRowAction * unreadAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"标记未读" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"标记未读");
//    }];
//    return @[deleteAction,unreadAction];
//}

#pragma mark - ===============删除===============
-(void)deleteClicked{
    //获取被选中的cell的indexPaths
    NSArray * selectedArr = [_tableView indexPathsForSelectedRows];
    if (selectedArr == nil) {
        return;
    }
    NSMutableArray * mularr = [NSMutableArray arrayWithArray:selectedArr];
    for (int i = 0; i < mularr.count-1; i++) {
        for (int j = 0; j < mularr.count-1-i; j++) {
            if ([mularr[j] row] < [mularr[j+1] row]) {
                [mularr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    
    for (NSIndexPath * indexPath in mularr) {
        NSMutableArray * arr = _dataSource[indexPath.section];
        [arr removeObjectAtIndex:indexPath.row];
    }
    //从视图中删除
    [_tableView deleteRowsAtIndexPaths:selectedArr withRowAnimation:(UITableViewRowAnimationFade)];
    
}

//非多选
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    UITableViewCellEditingStyleNone,
    //    UITableViewCellEditingStyleDelete,
    //    UITableViewCellEditingStyleInsert
    if ([indexPath section] == 0) {
        return UITableViewCellEditingStyleNone;
    }
    if ([indexPath section] == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleInsert;
    

}



@end
