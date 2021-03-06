//
//  ExerciseProgressViewController.m
//  xbsz
//
//  Created by lotus on 2017/4/27.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import "ExerciseProgressViewController.h"

static NSString *cellID = @"ProgressCollectionViewCell";
static NSInteger cellWidth = 35;
static NSInteger numberOfItems = 5;

@interface ExerciseProgressViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) ExerciseMode mode;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSDictionary *practicedDic;

@property (nonatomic, copy) NSDictionary *judgedDic;

@property (nonatomic, copy) ClickBlock clickBlock;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ExerciseProgressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注：以下动画失效  
//    NSIndexPath *path = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
//    [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = CXBackGroundColor;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(CX_PHONE_NAVIGATIONBAR_HEIGHT);
    }];
    
    [headView addSubview:self.titleLabel];
    [headView addSubview:self.cancelBtn];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(CX_PHONE_STATUSBAR_HEIGHT);
        make.height.mas_equalTo(44);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(CX_PHONE_STATUSBAR_HEIGHT);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(CX_PHONE_NAVIGATIONBAR_HEIGHT);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter/setter
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = CXSystemFont(16);
        _titleLabel.textColor = CXBlackColor;
        if(_mode == ExerciseModeRecite || _mode == ExerciseModeMistakes){
            _titleLabel.text = @"查看指定题目";
        }else{
            _titleLabel.text = @"答题卡";
        }
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = CXSystemFont(16);
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_cancelBtn setTitleColor:CXBlackColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(cellWidth  , cellWidth);
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = (CXScreenWidth - cellWidth*5 - 30)/4;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = CXWhiteColor;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ExerciseProgressCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_clickBlock)     _clickBlock((indexPath.section*numberOfItems)+indexPath.row);
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _total;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    ExerciseProgressCollectionViewCell *cell = (ExerciseProgressCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSInteger index = (indexPath.section*numberOfItems)+indexPath.row;
    if(index == _currentIndex){
        [cell updateUIByQuestionIndex:index+1 isFocused:YES];
    }else{
        [cell updateUIByQuestionIndex:index+1 isFocused:NO];
    }
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    if([_judgedDic containsObjectForKey:key]){
        NSInteger judge = [[_judgedDic valueForKey:key] integerValue];
        if(judge == 1){
            [cell updateUIByQuestionIsRight:YES];
        }else if(judge == -1){
            [cell updateUIByQuestionIsRight:NO];
        }
    }
    
    if([_practicedDic containsObjectForKey:key] && ![_judgedDic containsObjectForKey:key]){
        NSString *val = [_practicedDic valueForKey:key];
        if([val length] != 0){
            [cell updateUIByQuestionIsSelected:YES];
        }
    }
    
    return cell;
}


#pragma mark - private method

- (void)cancel{
    if(_clickBlock)     _clickBlock(_currentIndex);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateData:(ExerciseMode)mode
             total:(NSInteger)total
        practicedDic:(NSDictionary *)practicedDic
         judgedDic:(NSDictionary *)judgedDic
      currentIndex:(NSInteger)currentIndex
           clicked:(ClickBlock)clickBlock{
    _mode = mode;
    _total = total;
    _practicedDic = practicedDic;
    _judgedDic = judgedDic;         //模拟考试下传递过来的是错题进度  只有提交时间后才提交做题结果
    _currentIndex = currentIndex;
    _clickBlock = clickBlock;
}

@end


#pragma mark - 自定义的Cell

@implementation ExerciseProgressCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initCollectionCell];
    }
    return self;
}

- (void)initCollectionCell{
    [self.contentView addSubview:self.symbolLabel];
    [_symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)symbolLabel{
    if(!_symbolLabel){
        _symbolLabel = [[UILabel alloc] init];
        _symbolLabel = [[UILabel alloc] init];
        _symbolLabel.font = CXSystemFont(13);
        _symbolLabel.textColor = CXLightGrayColor;
        _symbolLabel.textAlignment = NSTextAlignmentCenter;
        _symbolLabel.layer.borderWidth = 1;
        _symbolLabel.layer.cornerRadius = cellWidth/2;
        _symbolLabel.layer.borderColor = CXLightGrayColor.CGColor;
        _symbolLabel.clipsToBounds = YES;
    }
    return _symbolLabel;
}

- (void)updateUIByQuestionIndex:(NSInteger)index{
    _symbolLabel.text = [NSString stringWithFormat:@"%ld",index];
}

- (void)updateUIByQuestionIndex:(NSInteger)index isFocused:(BOOL)isFocused{
    _symbolLabel.text = [NSString stringWithFormat:@"%ld",index];
    _symbolLabel.layer.borderWidth = 1;
    _symbolLabel.textColor = CXBlackColor;
    _symbolLabel.backgroundColor = CXWhiteColor;
    if(isFocused){
        _symbolLabel.layer.borderColor = CXBlackColor.CGColor;
        _symbolLabel.textColor = CXBlackColor;
    }else{
        _symbolLabel.layer.borderColor = CXLightGrayColor.CGColor;
        _symbolLabel.textColor = CXLightGrayColor;
    }
}

- (void)updateUIByQuestionIsSelected:(BOOL)isSelected{
    if(isSelected == YES){
        _symbolLabel.layer.borderWidth = 0;
        _symbolLabel.textColor = CXWhiteColor;
        _symbolLabel.backgroundColor = CXHexColor(0xea986c);
    }else{
        _symbolLabel.layer.borderWidth = 1;
        _symbolLabel.layer.borderColor = CXLightGrayColor.CGColor;
        _symbolLabel.textColor = CXLightGrayColor;
        _symbolLabel.backgroundColor = CXWhiteColor;
    }
}

- (void)updateUIByQuestionIsRight:(BOOL)isRight{
    if(isRight == YES){
        _symbolLabel.layer.borderWidth = 0;
        _symbolLabel.textColor = CXWhiteColor;
        _symbolLabel.backgroundColor = CXHexColor(0x08b292);
    }else{
        _symbolLabel.layer.borderWidth = 0;
        _symbolLabel.textColor = CXWhiteColor;
        _symbolLabel.backgroundColor = CXRedColor;
    }
}


@end
