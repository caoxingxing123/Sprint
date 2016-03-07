//
//  SPTBoardViewController.m
//  Sprint
//
//  Created by xxcao on 15/12/28.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "SPTBoardViewController.h"
#import "BoardCollectionViewCell.h"
#import "SPTNoteViewController.h"
#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"

#define kLineColor   ([UIColor colorWithWhite:0.8 alpha:1.0])

@interface SPTBoardViewController ()

@property(nonatomic,strong)NSMutableArray *datas;

@end

@implementation SPTBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"看板";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initCollectionView];
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark UICollectionView Datasource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.dataModel = self.datas[indexPath.row];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SPTNoteViewController *noteVC = [[SPTNoteViewController alloc] initWithNibName:@"SPTNoteViewController" bundle:nil];
    [self.navigationController pushViewController:noteVC animated:YES];
}
#pragma -mark
#pragma -mark init data
- (void)initData {
    if (!self.datas) {
        self.datas = [NSMutableArray array];
    } else {
        [self.datas removeAllObjects];
    }
    [self.datas addObject:@"0检查AppDelegate里友盟统计、TalkingData是否添加；"];
    [self.datas addObject:@"1检查GlobalDef里关于轻应用的宏kIsOpenAppModule是否打开；检查个推的key是否正确以及推送宏是否开启。"];
    [self.datas addObject:@"2对象或多个属性：equalTo 是变量数值元素： mas_equalTo 是常量好得很的合法化的回复的房贷反对反对奋斗奋斗奋斗分的房贷反对反对奋斗奋斗奋斗分的"];
    [self.datas addObject:@"3的发布的百分比的发布的百分比的发布的百分比的百分比的爆发的百分比的爆发的百分比的百分比的发布的爆发的百分比的爆发的百分比的部分你发的那发你的那发你的奶粉难得你愤怒的奶粉的哪个奶粉哪个你发那个发那个奶粉哪个你发那个发那个奶粉哪个奶粉哪个奶粉哪个奶粉哪个呢"];
    [self.datas addObject:@"4地标八点多吧反对反对奋斗奋斗奋斗房贷反对反对奋斗奋斗奋斗你你你分传递出的内存难得你才能到农村的女女女的的奶粉的南方那地方难得你愤怒的奶粉难得你愤怒的愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你愤怒的奶粉地方大幅度发毒奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你发你的你发你的南方那等你拿费大幅度发"];
    [self.datas addObject:@"5事件库不但允许你的应 获取 户已经存在的 历及提醒数据, 且它可以让你的应 为任何 历创建新的事件和提 醒。另外,事件库让 户可以编辑和删除他们的事件和提醒(整体叫做“ 历项”)。更 级的任务,诸如添加闹钟或指 定循环事件,也可以使 事件库完成。如果 历数据库有来 你的应 外部的更改发 ,事件库可以通过通知监测到, 这样你的应 可以做出适当的响应。使 事件库对 历项所做的更改会 动地同步到相关的 历(CalDAV - 是一种效 率手册同步协议,有些效率手册 如 Apple iCal、Mozilla Lightning/Sunbird 使用这一协议使其信息能与其它效率手册 如 Yahoo! 效率手册 进行交换;Exchange 等)。"];
    [self.datas addObject:@"6注意:如果你正在 iOS上开发,那么你可以选择使 事件库 户界 框架提供的事件视图控制器来让 户修改事件数据。有关如何使 这些事件视图控制器的信息,参 “为事件提供界 。使事件 EKEvent 的eventWithEventStore:  法创建 个新的事件。你可以通过设置 个新的事件或先前从 历数据库获取的事件的对应属性来编辑事件。你可以编辑的详细内容包括:"];
    [self.datas addObject:@"7个布尔值,它决定当前块返回后 enumerateEventsMatchingPredicate:usingBlock:  法是否应 该停 继续处理事件。如果是YES,那么与该谓词匹配的任何未处理的事件仍保持未处理状态。提 :记住,使 该 法会引起对 户的 历数据库的有效的修改。确认在你向 户请求批准时,让 户清楚地知道你所要执 的操作。"];
    [self.datas addObject:@"8事件库框架授权访问 户的 Calendar.app 和 Reminders.app 应 的信息。尽管是 两个不同的应 显  户的历和提醒数据,但确是同 个框架维护这份数据。同样地,存储这份数据的数据库叫做 历数据库,同时容纳 历和提醒信息。"];
    [self.datas addObject:@"9对于每一个指令,我们将会先列出及解释这个指令的语法,然后用一个例子来让读者了解这 个指令是如何被运用的。当您读完了这个网站的所有教材后,您将对 SQL 的语法会有一个 大致上的了解。另外,您将能够正确地运用 SQL 来由数据库中获取信息。笔者本身的经验 是,虽然要对 SQL 有很透彻的了解并不是一朝一夕可以完成的,可是要对 SQL 有个基本 的了解并不难。希望在看完这个网站后,您也会有同样的想法。"];
    [self.datas addObject:@"10是用来做什么的呢?一个最常用的方式是将资料从数据库中的表格内选出。从这一句回答 中,我们马上可以看到两个关键字: 从 (FROM) 数据库中的表格内选出 (SELECT)。(表 格是一个数据库内的结构,它的目的是储存资料。在表格处理这一部分中,我们会提到如何 使用 SQL 来设定表格。) 我们由这里可以看到最基本的 SQL 架构:"];
    
    [self.datas addObject:@"11检查AppDelegate里友盟统计、TalkingData是否添加；"];
    [self.datas addObject:@"12检查GlobalDef里关于轻应用的宏kIsOpenAppModule是否打开；检查个推的key是否正确以及推送宏是否开启。"];
    [self.datas addObject:@"13对象或多个属性：equalTo 是变量数值元素： mas_equalTo 是常量好得很的合法化的回复的房贷反对反对奋斗奋斗奋斗分的房贷反对反对奋斗奋斗奋斗分的"];
    [self.datas addObject:@"14的发布的百分比的发布的百分比的发布的百分比的百分比的爆发的百分比的爆发的百分比的百分比的发布的爆发的百分比的爆发的百分比的部分你发的那发你的那发你的奶粉难得你愤怒的奶粉的哪个奶粉哪个你发那个发那个奶粉哪个你发那个发那个奶粉哪个奶粉哪个奶粉哪个奶粉哪个呢"];
    [self.datas addObject:@"15地标八点多吧反对反对奋斗奋斗奋斗房贷反对反对奋斗奋斗奋斗你你你分传递出的内存难得你才能到农村的女女女的的奶粉的南方那地方难得你愤怒的奶粉难得你愤怒的愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你愤怒的奶粉地方大幅度发毒奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你发你的你发你的南方那等你拿费大幅度发"];
    [self.datas addObject:@"16事件库不但允许你的应 获取 户已经存在的 历及提醒数据, 且它可以让你的应 为任何 历创建新的事件和提 醒。另外,事件库让 户可以编辑和删除他们的事件和提醒(整体叫做“ 历项”)。更 级的任务,诸如添加闹钟或指 定循环事件,也可以使 事件库完成。如果 历数据库有来 你的应 外部的更改发 ,事件库可以通过通知监测到, 这样你的应 可以做出适当的响应。使 事件库对 历项所做的更改会 动地同步到相关的 历(CalDAV - 是一种效 率手册同步协议,有些效率手册 如 Apple iCal、Mozilla Lightning/Sunbird 使用这一协议使其信息能与其它效率手册 如 Yahoo! 效率手册 进行交换;Exchange 等)。"];
    [self.datas addObject:@"17注意:如果你正在 iOS上开发,那么你可以选择使 事件库 户界 框架提供的事件视图控制器来让 户修改事件数据。有关如何使 这些事件视图控制器的信息,参 “为事件提供界 。使事件 EKEvent 的eventWithEventStore:  法创建 个新的事件。你可以通过设置 个新的事件或先前从 历数据库获取的事件的对应属性来编辑事件。你可以编辑的详细内容包括:"];
    [self.datas addObject:@"18个布尔值,它决定当前块返回后 enumerateEventsMatchingPredicate:usingBlock:  法是否应 该停 继续处理事件。如果是YES,那么与该谓词匹配的任何未处理的事件仍保持未处理状态。提 :记住,使 该 法会引起对 户的 历数据库的有效的修改。确认在你向 户请求批准时,让 户清楚地知道你所要执 的操作。"];
    [self.datas addObject:@"19事件库框架授权访问 户的 Calendar.app 和 Reminders.app 应 的信息。尽管是 两个不同的应 显  户的历和提醒数据,但确是同 个框架维护这份数据。同样地,存储这份数据的数据库叫做 历数据库,同时容纳 历和提醒信息。"];
    [self.datas addObject:@"20对于每一个指令,我们将会先列出及解释这个指令的语法,然后用一个例子来让读者了解这 个指令是如何被运用的。当您读完了这个网站的所有教材后,您将对 SQL 的语法会有一个 大致上的了解。另外,您将能够正确地运用 SQL 来由数据库中获取信息。笔者本身的经验 是,虽然要对 SQL 有很透彻的了解并不是一朝一夕可以完成的,可是要对 SQL 有个基本 的了解并不难。希望在看完这个网站后,您也会有同样的想法。"];
    [self.datas addObject:@"21是用来做什么的呢?一个最常用的方式是将资料从数据库中的表格内选出。从这一句回答 中,我们马上可以看到两个关键字: 从 (FROM) 数据库中的表格内选出 (SELECT)。(表 格是一个数据库内的结构,它的目的是储存资料。在表格处理这一部分中,我们会提到如何 使用 SQL 来设定表格。) 我们由这里可以看到最基本的 SQL 架构:"];
}

static NSString *cellIdentify = @"BoardCollectionViewCellID";

- (void)initCollectionView {
    self.collectionViewLayOut.itemSize = Size(Screen_Width / 2, 128);
    self.collectionViewLayOut.minimumLineSpacing = 0.0;//行间距(最小值)
    self.collectionViewLayOut.minimumInteritemSpacing = 0.0;//item间距(最小值)
    self.collectionViewLayOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置section的边距

    [self.boardCollectionView registerNib:[UINib nibWithNibName:@"BoardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentify];
    //add line
    if (self.datas.count >= 2) {
        //add top line
        CALayer *topLayer = [CALayer layer];
        topLayer.backgroundColor = kLineColor.CGColor;
        topLayer.frame = CGRectMake(0, 0, Screen_Width, (1.0 / ([UIScreen mainScreen].scale)));
        [self.boardCollectionView.layer addSublayer:topLayer];

        //add bottom line
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.backgroundColor = kLineColor.CGColor;
        [self.boardCollectionView.layer addSublayer:bottomLayer];
        
        if (self.datas.count % 2 == 0) {
            bottomLayer.frame = CGRectMake(0, 128 * (self.datas.count / 2), Screen_Width, (1.0 / ([UIScreen mainScreen].scale)));
        } else {
            bottomLayer.frame = CGRectMake(0, 128 * ((self.datas.count + 1) / 2), Screen_Width / 2.0, (1.0 / ([UIScreen mainScreen].scale)));
            
            //add ver line
            CALayer *verLayer = [CALayer layer];
            verLayer.backgroundColor = kLineColor.CGColor;
            verLayer.frame = CGRectMake(Screen_Width / 2, 128 * (self.datas.count / 2), (1.0 / ([UIScreen mainScreen].scale)), 128);
            [self.boardCollectionView.layer addSublayer:verLayer];

            //add horizon line
            CALayer *horizonLayer = [CALayer layer];
            horizonLayer.backgroundColor = kLineColor.CGColor;
            horizonLayer.frame = CGRectMake(Screen_Width / 2, 128 * (self.datas.count / 2),Screen_Width / 2.0, (1.0 / ([UIScreen mainScreen].scale)));
            [self.boardCollectionView.layer addSublayer:horizonLayer];
        }
    }
    
    //下拉刷新
    WeakSelf;
    self.boardCollectionView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        //refresh code
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.boardCollectionView.mj_header endRefreshing];
        });
    }];
    //上拉加载更多
    self.boardCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //refresh code
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.boardCollectionView.mj_footer endRefreshing];
        });
    }];

}


@end
