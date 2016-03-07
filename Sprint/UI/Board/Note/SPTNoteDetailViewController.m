//
//  SPTNoteDetailViewController.m
//  Sprint
//
//  Created by xxcao on 16/2/25.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "SPTNoteDetailViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "NoteDetailCell.h"
#import "DetailModel.h"
#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"

@interface SPTNoteDetailViewController ()

@end

@implementation SPTNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = self.headerView;
    [self.table registerClass:[NoteDetailCell class] forCellReuseIdentifier:cellID];
    [Common removeExtraCellLines:self.table];
    [self creatModelsIsInit:YES];
    
    //下拉刷新
    WeakSelf;
    self.table.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        //refresh code
        [wself creatModelsIsInit:YES];
        [wself.table reloadData];
        [wself.table.mj_header endRefreshing];
    }];
    //上拉加载更多
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //refresh code
        [wself creatModelsIsInit:NO];
        [wself.table reloadData];
        [wself.table.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark getter and setter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = UIView.new;
        
        SDCycleScrollView *scrollView = SDCycleScrollView.new;
        NSArray *picImageNamesArray = @[ @"pic1.jpg",
                                         @"pic2.jpg",
                                         @"pic3.jpg",
                                         @"pic4.jpg",
                                         ];
        [_headerView addSubview:scrollView];
        scrollView.localizationImageNamesGroup = picImageNamesArray;
        scrollView.sd_layout.leftSpaceToView(_headerView,0).topSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).heightIs(200);
        
        //contentView
        UIView *contentView = [UIView new];
        [_headerView addSubview:contentView];
        contentView.sd_layout.leftSpaceToView(_headerView,0).topSpaceToView(scrollView,0).rightSpaceToView(_headerView,0).heightIs(60);
        
        //content view subview
        UIButton *shareBtn = [UIButton new];
        shareBtn.backgroundColor = [UIColor redColor];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        shareBtn.titleLabel.font = Font(13);
        [contentView addSubview:shareBtn];
        
        UIButton *topBtn = [UIButton new];
        topBtn.backgroundColor = [UIColor greenColor];
        [topBtn setTitle:@"点赞" forState:UIControlStateNormal];
        topBtn.titleLabel.font = Font(13);
        [contentView addSubview:topBtn];

        UIButton *downBtn = [UIButton new];
        downBtn.backgroundColor = [UIColor blueColor];
        [downBtn setTitle:@"批评" forState:UIControlStateNormal];
        downBtn.titleLabel.font = Font(13);
        [contentView addSubview:downBtn];

        CGFloat margin = (Screen_Width - 30 * 3) / 4.0;
        shareBtn.sd_layout.topSpaceToView(contentView,15).bottomSpaceToView(contentView,15).leftSpaceToView(contentView,margin).widthIs(30).heightIs(30);
        
        topBtn.sd_layout.topSpaceToView(contentView,15).bottomSpaceToView(contentView,15).leftSpaceToView(shareBtn,margin).widthIs(30).heightIs(30);

        downBtn.sd_layout.topSpaceToView(contentView,15).bottomSpaceToView(contentView,15).leftSpaceToView(topBtn,margin).rightSpaceToView(contentView,margin).widthIs(30).heightIs(30);


        //bottom line
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [_headerView addSubview:bottomLine];
        
        bottomLine.sd_layout.leftSpaceToView(_headerView,0).topSpaceToView(contentView,0).rightSpaceToView(_headerView,0).heightIs(1);
        
        [_headerView setupAutoHeightWithBottomView:bottomLine bottomMargin:0];

        [_headerView layoutSubviews];
    }
    return _headerView;
}

#pragma -mark
#pragma -mark UITableView DataSource and Delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

static NSString *cellID = @"cellIdentify";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NoteDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.dataModel = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView cellHeightForIndexPath:indexPath
                                                 model:self.datas[indexPath.row]
                                               keyPath:@"dataModel"
                                             cellClass:[NoteDetailCell class]
                                      contentViewWidth:Screen_Width];
    return height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma -mark
#pragma -mark init
- (NSMutableArray *)creatTextDatas {
    NSMutableArray *tmpArray = [NSMutableArray array];
    [tmpArray addObject:@"0检查AppDelegate里友盟统计、TalkingData是否添加；"];
    [tmpArray addObject:@"1检查GlobalDef里关于轻应用的宏kIsOpenAppModule是否打开；检查个推的key是否正确以及推送宏是否开启。"];
    [tmpArray addObject:@"2对象或多个属性：equalTo 是变量数值元素： mas_equalTo 是常量好得很的合法化的回复的房贷反对反对奋斗奋斗奋斗分的房贷反对反对奋斗奋斗奋斗分的"];
    [tmpArray addObject:@"3的发布的百分比的发布的百分比的发布的百分比的百分比的爆发的百分比的爆发的百分比的百分比的发布的爆发的百分比的爆发的百分比的部分你发的那发你的那发你的奶粉难得你愤怒的奶粉的哪个奶粉哪个你发那个发那个奶粉哪个你发那个发那个奶粉哪个奶粉哪个奶粉哪个奶粉哪个呢"];
    [tmpArray addObject:@"4地标八点多吧反对反对奋斗奋斗奋斗房贷反对反对奋斗奋斗奋斗你你你分传递出的内存难得你才能到农村的女女女的的奶粉的南方那地方难得你愤怒的奶粉难得你愤怒的愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你愤怒的奶粉地方大幅度发毒奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你发你的你发你的南方那等你拿费大幅度发"];
    [tmpArray addObject:@"5事件库不但允许你的应 获取 户已经存在的 历及提醒数据, 且它可以让你的应 为任何 历创建新的事件和提 醒。另外,事件库让 户可以编辑和删除他们的事件和提醒(整体叫做“ 历项”)。更 级的任务,诸如添加闹钟或指 定循环事件,也可以使 事件库完成。如果 历数据库有来 你的应 外部的更改发 ,事件库可以通过通知监测到, 这样你的应 可以做出适当的响应。使 事件库对 历项所做的更改会 动地同步到相关的 历(CalDAV - 是一种效 率手册同步协议,有些效率手册 如 Apple iCal、Mozilla Lightning/Sunbird 使用这一协议使其信息能与其它效率手册 如 Yahoo! 效率手册 进行交换;Exchange 等)。"];
    [tmpArray addObject:@"6注意:如果你正在 iOS上开发,那么你可以选择使 事件库 户界 框架提供的事件视图控制器来让 户修改事件数据。有关如何使 这些事件视图控制器的信息,参 “为事件提供界 。使事件 EKEvent 的eventWithEventStore:  法创建 个新的事件。你可以通过设置 个新的事件或先前从 历数据库获取的事件的对应属性来编辑事件。你可以编辑的详细内容包括:"];
    [tmpArray addObject:@"7个布尔值,它决定当前块返回后 enumerateEventsMatchingPredicate:usingBlock:  法是否应 该停 继续处理事件。如果是YES,那么与该谓词匹配的任何未处理的事件仍保持未处理状态。提 :记住,使 该 法会引起对 户的 历数据库的有效的修改。确认在你向 户请求批准时,让 户清楚地知道你所要执 的操作。"];
    [tmpArray addObject:@"8事件库框架授权访问 户的 Calendar.app 和 Reminders.app 应 的信息。尽管是 两个不同的应 显  户的历和提醒数据,但确是同 个框架维护这份数据。同样地,存储这份数据的数据库叫做 历数据库,同时容纳 历和提醒信息。"];
    [tmpArray addObject:@"9对于每一个指令,我们将会先列出及解释这个指令的语法,然后用一个例子来让读者了解这 个指令是如何被运用的。当您读完了这个网站的所有教材后,您将对 SQL 的语法会有一个 大致上的了解。另外,您将能够正确地运用 SQL 来由数据库中获取信息。笔者本身的经验 是,虽然要对 SQL 有很透彻的了解并不是一朝一夕可以完成的,可是要对 SQL 有个基本 的了解并不难。希望在看完这个网站后,您也会有同样的想法。"];
    return tmpArray;
}

- (void)creatModelsIsInit:(BOOL)isInit {
    //load data
    if (isInit) {
        if (!_datas) {
            _datas = [NSMutableArray new];
        } else {
            [_datas removeAllObjects];
        }
    }
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = [self creatTextDatas];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    
    for (int i = 0; i < textArray.count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        DetailModel *model = [DetailModel new];
        model.iconStr = iconImageNamesArray[iconRandomIndex];
        model.nameStr = namesArray[nameRandomIndex];
        model.contentStr = textArray[contentRandomIndex];
        model.timeStr = @"1分钟前";

        
        // 模拟“随机图片”
        int random = arc4random_uniform(10);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.photeNameArry = [temp copy];
        }
        [self.datas addObject:model];
    }
}


@end
