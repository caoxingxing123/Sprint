//
//  SPTNoteViewController.m
//  Sprint
//
//  Created by xxcao on 16/2/22.
//  Copyright © 2016年 xxcao. All rights reserved.
//

#import "SPTNoteViewController.h"
#import "NoteCollectionViewCell.h"
#import "NoteHeaderReusableView.h"
#import "SPTNoteDetailViewController.h"
#import "UIView+YYAdd.h"
#import "DraggableCollectionViewFlowLayout.h"
#import "MJChiBaoZiHeader.h"
#import "MBProgressController.h"

#define kPHASE_COUNT 10

@interface SPTNoteViewController ()

@end

@implementation SPTNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阶段1";
    [self initData];
    [self initPhases];
}

- (void)dealloc {
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UICollectionView class]]) {
            [obj removeObserver:self forKeyPath:@"contentSize"];
        }
    }];
}

#pragma -mark
#pragma -mark UICollectionView DataSource & Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(NSArray *)self.datas[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.dataModel = self.datas[indexPath.section][indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NoteHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
//..
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //跳转note 详情
    SPTNoteDetailViewController *noteDetailVC = [[SPTNoteDetailViewController alloc] initWithNibName:@"SPTNoteDetailViewController" bundle:nil];
    [self.navigationController pushViewController:noteDetailVC animated:YES];
}


- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.datas[indexPath.section] count]) {
        return NO;
    }
    return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (!indexPath || !toIndexPath) {
        return NO;
    }
    // Prevent item from being moved to index 0
    //    if (toIndexPath.item == 0) {
    //        return NO;
    //    }
    return YES;
}

- (void)collectionView:(LSCollectionViewHelper *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section == toIndexPath.section) {
        NSMutableArray *data = [self.datas[fromIndexPath.section] mutableCopy];
        NSString *fromcontent = data[fromIndexPath.item];
        [data removeObjectAtIndex:fromIndexPath.item];
        [data insertObject:fromcontent atIndex:toIndexPath.item];
        [self.datas replaceObjectAtIndex:fromIndexPath.section withObject:data];
    } else {
        NSMutableArray *data1 = [self.datas[fromIndexPath.section] mutableCopy];
        NSMutableArray *data2 = [self.datas[toIndexPath.section] mutableCopy];
        NSString *content = data1[fromIndexPath.item];
        [data1 removeObjectAtIndex:fromIndexPath.item];
        [data2 insertObject:content atIndex:toIndexPath.item];
        [self.datas replaceObjectAtIndex:fromIndexPath.section withObject:data1];
        [self.datas replaceObjectAtIndex:toIndexPath.section withObject:data2];
    }
}

#pragma -mark
#pragma -mark Init Methods
- (void)initPhases {
    _phaseCount = kPHASE_COUNT;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = Size(Screen_Width * kPHASE_COUNT, Screen_Height - 64.0);
    [self initCollectionViewWithCount:kPHASE_COUNT];
}

static NSString *collectionCellID = @"collectionCellIdentify";
static NSString *collectionHeaderID = @"HeaderIdentify";

- (void)initCollectionViewWithCount:(NSInteger)count {
    
    if(!self.layers) {
        self.layers = [NSMutableArray array];
    } else {
        [self.layers removeAllObjects];
    }
    
    
    if (count == 0) {
        return;
    }
    else if (count >= 1 && count <= 2){
        for (int i = 0; i < count; i++) {
            [self drawCustomCollectionViewByIndex:i];
        }
    }
    else {
        for (int i = 0; i < 3; i++) {
            [self drawCustomCollectionViewByIndex:i];
        }
    }
}

#pragma -mark
#pragma -mark KVO
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    if ([object isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)object;
        NSInteger index = collectionView.tag - 2016;
        if (index < self.layers.count && index >= 0) {
            UIImageView *layer = (UIImageView *)self.layers[index];
            layer.top = -1 * collectionView.contentOffset.y + 8.0;
            layer.height = collectionView.contentSize.height - 16.0;
        }
    }
}

#pragma -mark
#pragma -mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //trigger KVO
    [scrollView contentSize];
//    CGSize size = scrollView.contentSize;
//    NSLog(@"%@",NSStringFromCGSize(size));
    
    if (_phaseCount >= 3) {
        if (![scrollView isKindOfClass:[UICollectionView class]]) {
            UIScrollView *tmpScrollView = (UIScrollView *)self.view;
            int currentPage = floor((tmpScrollView.contentOffset.x - Screen_Width / 2.0) / Screen_Width) + 1;
            if(currentPage >=1 && currentPage <= _phaseCount - 3) {
                UIView *futureView = [tmpScrollView viewWithTag:2016 + (currentPage + 2)];
                if (!futureView || ![futureView isKindOfClass:[UICollectionView class]]) {
                    [self drawCustomCollectionViewByIndex:currentPage + 2];
                }
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        if(decelerate) {
            int currentPage = floor((scrollView.contentOffset.x - Screen_Width / 2.0) / Screen_Width) + 1;
            self.title = [NSString stringWithFormat:@"阶段%d",currentPage + 1];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        int currentPage = floor((scrollView.contentOffset.x - Screen_Width / 2.0) / Screen_Width) + 1;
        self.title = [NSString stringWithFormat:@"阶段%d",currentPage + 1];
    }
}

#pragma -mark
#pragma -mark Test Data
- (void)initData {
    if (!self.datas) {
        self.datas = [NSMutableArray array];
    } else {
        [self.datas removeAllObjects];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    for(int s = 0; s < 5; s++) {
        if(data.count > 0){
            [data removeAllObjects];
        }
        [data addObject:@"0检查AppDelegate里友盟统计、TalkingData是否添加；"];
        [data addObject:@"1检查GlobalDef里关于轻应用的宏kIsOpenAppModule是否打开；检查个推的key是否正确以及推送宏是否开启。"];
        [data addObject:@"2对象或多个属性：equalTo是变量数值元素：mas_equalTo是常量好得很的合法化的回复的房贷反对反对奋斗奋斗奋斗分的房贷反对反对奋斗奋斗奋斗分的"];
        [data addObject:@"3的发布的百分比的发布的百分比的发布的百分比的百分比的爆发的百分比的爆发的百分比的百分比的发布的爆发的百分比的爆发的百分比的部分你发的那发你的那发你的奶粉难得你愤怒的奶粉的哪个奶粉哪个你发那个发那个奶粉哪个你发那个发那个奶粉哪个奶粉哪个奶粉哪个奶粉哪个呢"];
        [data addObject:@"4地标八点多吧反对反对奋斗奋斗奋斗房贷反对反对奋斗奋斗奋斗你你你分传递出的内存难得你才能到农村的女女女的的奶粉的南方那地方难得你愤怒的奶粉难得你愤怒的愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你愤怒的奶粉地方大幅度发毒奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你发你的你发你的南方那等你拿费大幅度发"];
        [data addObject:@"5事件库不但允许你的应获取户已经存在的历及提醒数据,且它可以让你的应为任何历创建新的事件和提醒。另外,事件库让户可以编辑和删除他们的事件和提醒(整体叫做“历项”)。更级的任务,诸如添加闹钟或指定循环事件,也可以使事件库完成。如果历数据库有来你的应外部的更改发,事件库可以通过通知监测到,这样你的应可以做出适当的响应。使事件库对历项所做的更改会动地同步到相关的历(CalDAV-是一种效率手册同步协议,有些效率手册如Apple iCal、Mozilla Lightning/Sunbird 使用这一协议使其信息能与其它效率手册如 Yahoo! 效率手册进行交换;Exchange 等)。"];
        [data addObject:@"6注意:如果你正在iOS上开发,那么你可以选择使事件库户界框架提供的事件视图控制器来让户修改事件数据。有关如何使这些事件视图控制器的信息,参“为事件提供界。使事件EKEvent的eventWithEventStore:法创建个新的事件。你可以通过设置个新的事件或先前从历数据库获取的事件的对应属性来编辑事件。你可以编辑的详细内容包括:"];
        [data addObject:@"7个布尔值,它决定当前块返回后 enumerateEventsMatchingPredicate:usingBlock:  法是否应该停继续处理事件。如果是YES,那么与该谓词匹配的任何未处理的事件仍保持未处理状态。提 :记住,使 该 法会引起对 户的历数据库的有效的修改。确认在你向户请求批准时,让户清楚地知道你所要执的操作。"];
        [data addObject:@"8事件库框架授权访问户的 Calendar.app和Reminders.app应的信息。尽管是两个不同的应显户的历和提醒数据,但确是同个框架维护这份数据。同样地,存储这份数据的数据库叫做历数据库,同时容纳历和提醒信息。"];
        [data addObject:@"9对于每一个指令,我们将会先列出及解释这个指令的语法,然后用一个例子来让读者了解这 个指令是如何被运用的。当您读完了这个网站的所有教材后,您将对SQL的语法会有一个大致上的了解。另外,您将能够正确地运用SQL 来由数据库中获取信息。笔者本身的经验是,虽然要对SQL有很透彻的了解并不是一朝一夕可以完成的,可是要对SQL有个基本的了解并不难。希望在看完这个网站后,您也会有同样的想法。"];
        [data addObject:@"10是用来做什么的呢?一个最常用的方式是将资料从数据库中的表格内选出。从这一句回答中,我们马上可以看到两个关键字: 从 (FROM) 数据库中的表格内选出 (SELECT)。(表格是一个数据库内的结构,它的目的是储存资料。在表格处理这一部分中,我们会提到如何 使用SQL来设定表格。) 我们由这里可以看到最基本的SQL架构:"];
        [data addObject:@"11检查AppDelegate里友盟统计、TalkingData是否添加；"];
        [data addObject:@"12检查GlobalDef里关于轻应用的宏kIsOpenAppModule是否打开；检查个推的key是否正确以及推送宏是否开启。"];
        [data addObject:@"13对象或多个属性：equalTo 是变量数值元素：mas_equalTo是常量好得很的合法化的回复的房贷反对反对奋斗奋斗奋斗分的房贷反对反对奋斗奋斗奋斗分的"];
        [data addObject:@"14的发布的百分比的发布的百分比的发布的百分比的百分比的爆发的百分比的爆发的百分比的百分比的发布的爆发的百分比的爆发的百分比的部分你发的那发你的那发你的奶粉难得你愤怒的奶粉的哪个奶粉哪个你发那个发那个奶粉哪个你发那个发那个奶粉哪个奶粉哪个奶粉哪个奶粉哪个呢"];
        [data addObject:@"15地标八点多吧反对反对奋斗奋斗奋斗房贷反对反对奋斗奋斗奋斗你你你分传递出的内存难得你才能到农村的女女女的的奶粉的南方那地方难得你愤怒的奶粉难得你愤怒的愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你愤怒的奶粉地方大幅度发毒奶粉难得你愤怒的奶粉难得你愤怒的奶粉的奶粉难得你发你的你发你的南方那等你拿费大幅度发"];
        [data addObject:@"16事件库不但允许你的应获取户已经存在的历及提醒数据, 且它可以让你的应为任何历创建新的事件和提醒。另外,事件库让户可以编辑和删除他们的事件和提醒(整体叫做“历项”)。更级的任务,诸如添加闹钟或指定循环事件,也可以使事件库完成。如果历数据库有来你的应外部的更改发,事件库可以通过通知监测到,这样你的应可以做出适当的响应。使事件库对历项所做的更改会动地同步到相关的 历(CalDAV-是一种效 率手册同步协议,有些效率手册如 Apple iCal、Mozilla Lightning/Sunbird 使用这一协议使其信息能与其它效率手册如Yahoo! 效率手册进行交换;Exchange等)。"];
        [data addObject:@"17注意:如果你正在iOS上开发,那么你可以选择使事件库户界 框架提供的事件视图控制器来让 户修改事件数据。有关如何使 这些事件视图控制器的信息,参“为事件提供界。使事件EKEvent的eventWithEventStore:法创建个新的事件。你可以通过设置个新的事件或先前从历数据库获取的事件的对应属性来编辑事件。你可以编辑的详细内容包括:"];
        [data addObject:@"18个布尔值,它决定当前块返回后 enumerateEventsMatchingPredicate:usingBlock:法是否应 该停 继续处理事件。如果是YES,那么与该谓词匹配的任何未处理的事件仍保持未处理状态。提:记住,使该法会引起对户的 历数据库的有效的修改。确认在你向户请求批准时,让户清楚地知道你所要执的操作。"];
        [data addObject:@"19事件库框架授权访问户的Calendar.app和Reminders.app应的信息。尽管是两个不同的应显户的历和提醒数据,但确是同个框架维护这份数据。同样地,存储这份数据的数据库叫做历数据库,同时容纳历和提醒信息。"];
        [data addObject:@"20对于每一个指令,我们将会先列出及解释这个指令的语法,然后用一个例子来让读者了解这个指令是如何被运用的。当您读完了这个网站的所有教材后,您将对SQL的语法会有一个大致上的了解。另外,您将能够正确地运用SQL 来由数据库中获取信息。笔者本身的经验是,虽然要对SQL有很透彻的了解并不是一朝一夕可以完成的,可是要对SQL有个基本的了解并不难。希望在看完这个网站后,您也会有同样的想法。"];
        [data addObject:@"21是用来做什么的呢?一个最常用的方式是将资料从数据库中的表格内选出。从这一句回答中,我们马上可以看到两个关键字: 从(FROM)数据库中的表格内选出(SELECT)。(表格是一个数据库内的结构,它的目的是储存资料。在表格处理这一部分中,我们会提到如何使用SQL来设定表格。) 我们由这里可以看到最基本的SQL架构:"];

        [self.datas addObject:data];
    }
}

- (void)drawCustomCollectionViewByIndex:(NSInteger)idx {
    
    DraggableCollectionViewFlowLayout *flowLayout = [[DraggableCollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 10);//设置section的边距
    flowLayout.minimumLineSpacing = 10.0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 10.0;//item间距(最小值)
    CGFloat itemWidth = ((Screen_Width - 20) - 10 * 5) / 4.0;
    flowLayout.itemSize = Size(itemWidth, itemWidth);
    flowLayout.headerReferenceSize = CGSizeMake(Screen_Width, 50.0f);  //设置head大小
    
    UICollectionView *tmpCollectionView = [[UICollectionView alloc] initWithFrame:Frame(idx * Screen_Width, 0, Screen_Width, ((UIScrollView *)self.view).contentSize.height) collectionViewLayout:flowLayout];
    [tmpCollectionView registerNib:[UINib nibWithNibName:@"NoteCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionCellID];
    [tmpCollectionView registerNib:[UINib nibWithNibName:@"NoteHeaderReusableView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderID];
    
    tmpCollectionView.delegate = self;
    tmpCollectionView.dataSource = self;
    
    tmpCollectionView.draggable = YES;//allow draggable
    
    tmpCollectionView.backgroundColor = [UIColor whiteColor];
    tmpCollectionView.tag = 2016 + idx;
    //
    UIImageView *lineLayer = [[UIImageView alloc] initWithFrame:Frame(24.0, 0, 1.0 / ([UIScreen mainScreen].scale), tmpCollectionView.contentSize.height - 10)];
    lineLayer.backgroundColor = [UIColor blackColor];
    
    UIView *view = [[UIView alloc] initWithFrame:tmpCollectionView.bounds];
    [view addSubview:lineLayer];
    view.backgroundColor = [UIColor whiteColor];
    tmpCollectionView.backgroundView = view;
    [self.layers addObject:lineLayer];
    
    [self.view addSubview:tmpCollectionView];
    
    [tmpCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    //add pull refresh
    tmpCollectionView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tmpCollectionView.mj_header endRefreshing];
        });
    }];
}

@end
