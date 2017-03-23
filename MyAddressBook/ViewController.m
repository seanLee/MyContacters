//
//  ViewController.m
//  MyAddressBook
//
//  Created by Sean on 2017/3/23.
//  Copyright © 2017年 sean. All rights reserved.
//

#import "ViewController.h"
#import "Contacter.h"
#import "ContacterCell.h"
#import "NSString+Common.h"
#import <AddressBook/AddressBook.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray *myContacters;
@property (strong, nonatomic) NSArray *cKeyArray;
@property (strong, nonatomic) NSMutableDictionary *cKeyDict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myTableView = ({
        UITableView *myTableView = [[UITableView alloc] init];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [myTableView registerClass:[ContacterCell class] forCellReuseIdentifier:kCellIdentifier_ContacterCell];
        [self.view addSubview:myTableView];
        myTableView;
    });
    
    {
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _myContacters = [NSMutableArray new];
    _cKeyDict = [NSMutableDictionary new];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //为了解决卡顿问题
        __strong typeof(self) self = weakSelf;
        [self getAddressBook];
    });
}

- (void)getAddressBook {
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook = nil;
    //创建通讯簿的引用
    addBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //创建一个出事信号量为0的信号
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error) {
        //greanted为YES是表示用户允许，否则为不允许
        if (!greanted) {
            tip=1;
        }
        //发送一次信号
        dispatch_semaphore_signal(sema);
    });
    //等待信号触发
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    for (int i = 0; i < number; i++) {
        ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
        Contacter *contacter = [Contacter new];
        //获取当前联系人名字
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        if (lastName.length == 0) {
            contacter.name = firstName;
        } else if (firstName.length == 0) {
            contacter.name = lastName;
        } else {
            contacter.name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        }
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        NSInteger phoneCout = ABMultiValueGetCount(phones);
        if (phoneCout == 0) {
            continue;
        }
        contacter.phone = ((__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, 0));
        if ([contacter.phone containsString:@"-"]) {
            contacter.phone = [contacter.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        [_myContacters addObject:contacter];
    }
    [self sort];
}

- (void)sort {
    for (Contacter *cont in _myContacters) {
        NSString *pinyin = [cont.name firstPinyinCharacter];
        if (!pinyin) pinyin = @"#";
        NSMutableArray *listArry;
        if ([_cKeyDict.allKeys containsObject:pinyin]) {
            listArry = _cKeyDict[pinyin];
            [listArry addObject:cont];
            [_cKeyDict setObject:listArry forKey:pinyin];
        } else {
            listArry = [NSMutableArray new];
            [listArry addObject:cont];
            [_cKeyDict setObject:listArry forKey:pinyin];
        }
    }
    _cKeyArray = [_cKeyDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return obj1 > obj2;
    }];
    
    [self.myTableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cKeyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _cKeyArray[section];
    NSArray *list = _cKeyDict[key];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ContacterCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_cKeyArray indexOfObject:title];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _cKeyArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ContacterCell forIndexPath:indexPath];
    NSString *key = _cKeyArray[indexPath.section];
    NSArray *list = _cKeyDict[key];
    cell.curContacter = list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
