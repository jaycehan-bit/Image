//
//  JCComplexTableViewAdapter.m
//  JCImage
//
//  Created by jaycehan on 2024/1/29.
//

#import "JCComplexTableViewCell.h"
#import "JCComplexTableViewAdapter.h"
#import "JCComplexTableViewCellModel.h"
#import "JCImage-Swift.h"

static NSString * const JCComplexTableViewCellIdentifier = @"JCComplexTableViewCellIdentifier";
static NSString * const JCComplexString = @"✨哈🤪哈🫥哈🎃哈💤哈🌦️";
static NSArray * const imageList = @[@"Riven.jpg",  @"Seraphine.jpg", @"Akali.jpg", @"Teemo.png", @"Katarina.jpg"];

@interface JCComplexTableViewAdapter ()

@property (nonatomic, strong) NSMutableArray<JCComplexTableViewCellModel *> *dataList;

@end

@implementation JCComplexTableViewAdapter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self mockCellData];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCComplexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JCComplexTableViewCellIdentifier];
    if (!cell) {
        cell = [[JCComplexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JCComplexTableViewCellIdentifier];
    }
    [cell bindViewModel:self.dataList[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JCComplexTableViewCell heightForViewModel:self.dataList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Mock

- (void)mockCellData {
    for (NSUInteger index = 0; index < 50; index ++) {
        JCComplexTableViewCellModel *viewModel = [self.class generateRandomViewModel];
        [self.dataList addObject:viewModel];
    }
}

+ (JCComplexTableViewCellModel *)generateRandomViewModel {
    NSString *text = @"";
    for (NSUInteger i = 0; i < (arc4random() % 10) + 2; i ++) {
        text = [text stringByAppendingString:JCComplexString];
    }
    UIImage *image = nil;
    if (arc4random() % 2) {
        image = [UIImage imageNamed:imageList[(arc4random() % imageList.count)]];
    }
    return [[JCComplexTableViewCellModel alloc] initWithTitle:text image:image];
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

+ (void)timeConsumingMethod {
    [self.class readLocalFileWithName:@"Package"];
    for (NSUInteger index = 0; index < 1000; index ++) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        [formatter stringFromDate:[NSDate date]];
    }
}

+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return dic;
}

@end
