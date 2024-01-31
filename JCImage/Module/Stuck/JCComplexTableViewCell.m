//
//  JCComplexTableViewCell.m
//  JCImage
//
//  Created by jaycehan on 2024/1/26.
//

#import "JCComplexTableViewCell.h"
#import "JCImage-Swift.h"

#define K_TEXT_FONT [UIFont fontWithName:@"PingFangSC-Semibold" size:13]

static const CGFloat JCComplexTableViewCellPadding = 16.0;
static const CGFloat JCComplexTableViewCellImageWidth = 121.0;
static const CGFloat JCComplexTableViewCellImageHeight = 68.0;

@interface JCComplexTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) JCComplexTableViewCellModel *viewModel;

@end

@implementation JCComplexTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.titleLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarView.frame = CGRectMake(JCComplexTableViewCellPadding, JCComplexTableViewCellPadding,
                                      JCComplexTableViewCellImageWidth, JCComplexTableViewCellImageHeight);
    CGFloat textLeft = 0;
    if (self.viewModel.image) {
        self.avatarView.hidden = NO;
        textLeft = self.avatarView.frame.origin.x + JCComplexTableViewCellImageWidth + JCComplexTableViewCellPadding;
    } else {
        self.avatarView.hidden = YES;
        textLeft = JCComplexTableViewCellPadding;
    }
    self.titleLabel.frame = CGRectMake(textLeft, JCComplexTableViewCellPadding,
                                       self.bounds.size.width - textLeft - JCComplexTableViewCellPadding, self.bounds.size.height - 2 * JCComplexTableViewCellPadding);
}

- (void)bindViewModel:(JCComplexTableViewCellModel *)viewModel {
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    self.avatarView.image = viewModel.image;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarView.backgroundColor = UIColor.clearColor;
    }
    return _avatarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = K_TEXT_FONT;
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

+ (CGFloat)heightForViewModel:(JCComplexTableViewCellModel *)viewModel {
    if (!viewModel.title.length) {
        return 0;
    }
    CGFloat maxLength = [JCCommonUnit mainWindow].bounds.size.width - JCComplexTableViewCellPadding * 2;
    if (viewModel.image) {
        maxLength = maxLength - JCComplexTableViewCellImageWidth - JCComplexTableViewCellPadding;
    }
    CGRect rect = [viewModel.title boundingRectWithSize:CGSizeMake(maxLength, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName : K_TEXT_FONT} context:nil];
    if (viewModel.image) {
        rect.size.height = MAX(rect.size.height, JCComplexTableViewCellImageHeight);
    }
    return ceilf(rect.size.height + 2 * JCComplexTableViewCellPadding);
}

@end
