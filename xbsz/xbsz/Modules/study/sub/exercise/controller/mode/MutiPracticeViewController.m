//
//  PracticeViewController.m
//  xbsz
//
//  Created by lotus on 2017/4/28.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import "MutiPracticeViewController.h"
#import "StudyUtil.h"
#import "ExerciseProgressViewController.h"
#import "QuestionCollectionViewCell.h"

static NSString *cellID = @"ExercisePracticeQuestionCellID";
static NSInteger bottomHeight = 45;

@interface MutiPracticeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QuestionOptionDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *gotoBtn;

@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UILabel *preLabel;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UILabel *nextLabel;

@property (nonatomic, copy) NSArray *questions;         //题目集合

@property (nonatomic, assign) NSInteger index;          //cell索引

@property (nonatomic, strong) NSMutableDictionary *practicedDic;

@property (nonatomic, strong) NSMutableDictionary *judgedDic;

@end

@implementation MutiPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.customNavBarView addSubview:self.gotoBtn];
    self.customNavBarView.backgroundColor  = CXBackGroundColor;
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CXScreenHeight-[self getStartOriginY]-bottomHeight);
        make.width.mas_equalTo(CXScreenWidth);
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.customNavBarView.mas_bottom);
    }];
    
    [self addBottomView];
    
    [self loadData];
    self.title = [NSString stringWithFormat:@"1/%ld",[_questions count]];
    _index = 0;         //初始化cell索引为0
    _practicedDic = [[NSMutableDictionary alloc] init];
    _judgedDic = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//加载题库数据
- (void)loadData{
    _questions = [StudyUtil getQuestions:_type isSingle:NO chapterIndex:_chapterIndex];
    CXLog(@"加载题目数据完成");
}

- (void)addBottomView{
    UIView *bottomLeftBgView = [[UIView alloc] init];
    bottomLeftBgView.backgroundColor = CXBackGroundColor;
    UIView *bottomRightBgView = [[UIView alloc] init];
    bottomRightBgView.backgroundColor = CXBackGroundColor;
    
    [bottomLeftBgView addSubview:self.preBtn];
    [bottomLeftBgView addSubview:self.preLabel];
    
    [bottomRightBgView addSubview:self.nextBtn];
    [bottomRightBgView addSubview:self.nextLabel];
    [self.view addSubview:bottomLeftBgView];
    [self.view addSubview:bottomRightBgView];
    [bottomLeftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(bottomHeight);
        make.width.mas_equalTo(CXScreenWidth/2);
    }];
    
    [_preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomLeftBgView.mas_centerX);
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(bottomLeftBgView.mas_top);
    }];
    
    [_preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomLeftBgView.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(13);
        make.bottom.mas_equalTo(bottomLeftBgView.mas_bottom).mas_offset(-2);
        
    }];
    
    [bottomRightBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(bottomHeight);
        make.width.mas_equalTo(CXScreenWidth/2);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomRightBgView.mas_centerX);
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(bottomLeftBgView.mas_top);
    }];
    
    [_nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomRightBgView.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(13);
        make.bottom.mas_equalTo(bottomRightBgView.mas_bottom).mas_offset(-2);
    }];
}


#pragma mark - getter/setter

- (UIButton *)gotoBtn{
    if(!_gotoBtn){
        _gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoBtn.frame = CGRectMake(CXScreenWidth - 49, 20, 44, 44);
        [_gotoBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_gotoBtn setImage:[UIImage imageNamed:@"question_goto"] forState:UIControlStateNormal];
        [_gotoBtn setImage:[UIImage imageNamed:@"question_goto"] forState:UIControlStateHighlighted];
        [_gotoBtn addTarget:self action:@selector(questionGoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoBtn;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(CXScreenWidth , CXScreenHeight-[self getStartOriginY]-bottomHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = CXWhiteColor;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[QuestionCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}


- (UIButton *)preBtn{
    if(!_preBtn){
        _preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preBtn setImage:[UIImage imageNamed:@"question_pre"] forState:UIControlStateNormal];
        [_preBtn addTarget:self action:@selector(pre) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preBtn;
}

- (UILabel *)preLabel{
    if(!_preLabel){
        _preLabel = [[UILabel alloc] init];
        _preLabel.font = CXSystemFont(12);
        _preLabel.textAlignment = NSTextAlignmentCenter;
        _preLabel.textColor = CXHexColor(0x08b292);
        _preLabel.text = @"无";
        _preLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pre)];
        [_preLabel addGestureRecognizer:tap];
        [_preLabel sizeToFit];
    }
    return _preLabel;
}

- (UIButton *)nextBtn{
    if(!_nextBtn){
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageNamed:@"question_next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UILabel *)nextLabel{
    if(!_nextLabel){
        _nextLabel = [[UILabel alloc] init];
        _nextLabel.font = CXSystemFont(12);
        _nextLabel.textAlignment = NSTextAlignmentCenter;
        _nextLabel.textColor = CXHexColor(0x08b292);
        _nextLabel.text = @"下一题";
        _nextLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
        [_nextLabel addGestureRecognizer:tap];
        [_nextLabel sizeToFit];
    }
    return _nextLabel;
}
#pragma mark - UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_questions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    QuestionCollectionViewCell *cell = (QuestionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.baseDelegate = self;
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    if([_judgedDic containsObjectForKey:key]){
        [cell updateUIByQuestion:[_questions objectAtIndex:indexPath.row] allowSelect:NO];
    }else{
        [cell updateUIByQuestion:[_questions objectAtIndex:indexPath.row] allowSelect:YES];
    }
    //从已做过的记录中回复做题记录
    if([_practicedDic containsObjectForKey:key]){
        NSString *selectedIndexs = [_practicedDic valueForKey:key];
        [cell showMutiPracticeAnswer:selectedIndexs];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat startX = scrollView.contentOffset.x;
    NSInteger index = startX/CXScreenWidth;
    _index = index;
    self.title = [NSString stringWithFormat:@"%ld/%ld",index+1,[_questions count]];
    [self updatePreAndNextLabel:_index];
}


#pragma mark - ExerciseChapterTableViewDelegate

- (void)selectOption:(NSInteger)selectedIndex{

    NSString *key = [NSString stringWithFormat:@"%ld",_index];
    NSString *newValue = [NSString stringWithFormat:@"%ld",selectedIndex];
    
    if([_judgedDic containsObjectForKey:key])  return;
    
    BOOL isSelected = YES;
    if([_practicedDic containsObjectForKey:key]){
        NSString *value = [_practicedDic valueForKey:key];
        if([value containsString:newValue]){
            isSelected = NO;
            value = [value stringByReplacingOccurrencesOfString:newValue withString:@""];
            [_practicedDic setValue:value forKey:key];
        }else{
            isSelected = YES;
            value = [NSString stringWithFormat:@"%@%@",value,newValue];
            [_practicedDic setValue:value forKey:key];
        }
    }else{
        isSelected = YES;
        [_practicedDic setValue:newValue forKey:key];
    }
    
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:_index inSection:0];
    QuestionCollectionViewCell *cell = (QuestionCollectionViewCell *)[_collectionView cellForItemAtIndexPath:path];
    [cell setTemporarySelected:[_practicedDic objectForKey:key]];
    
}

- (void)questionGoto{
    ExerciseProgressViewController *progressVC = [ExerciseProgressViewController controller];
    [progressVC updateData:_mode total:[_questions count] judgedDic:_judgedDic currentIndex:_index clicked:^(NSInteger index) {
        if(index >= 0){
            _index = index;
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self updatePreAndNextLabel:index];
        }
    }];
    [self presentViewController:progressVC animated:YES completion:nil];
}

#pragma mark - 私有方法

- (void)pre{
    if(_index <= 0){
        [ToastView showErrorWithStaus:@"没有上一题了"];
        return;
    }
    --_index;
    NSIndexPath *path = [NSIndexPath indexPathForRow:_index inSection:0];
    [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self updatePreAndNextLabel:_index];
}

- (void)next{
    if(_index == [_questions count] -1){
        [ToastView showErrorWithStaus:@"没有下一题了"];
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",_index];
    if([_judgedDic containsObjectForKey:key] ||[_practicedDic objectForKey:key] == nil){
        ++_index;
        NSIndexPath *path = [NSIndexPath indexPathForRow:_index inSection:0];
        [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self updatePreAndNextLabel:_index];
        
    }else{
        NSIndexPath *path = [NSIndexPath indexPathForRow:_index inSection:0];
        QuestionCollectionViewCell *cell = (QuestionCollectionViewCell *)[_collectionView cellForItemAtIndexPath:path];
        BOOL isRight = [cell showMutiPracticeAnswer:[_practicedDic objectForKey:key]];
        if(isRight == YES){
            [_judgedDic setValue:@"1" forKey:key];
            [self performSelector:@selector(next) withObject:nil afterDelay:0.3];
        }else{
            [_judgedDic setValue:@"-1" forKey:key];
        }
    }
    
}

- (void)updatePreAndNextLabel:(NSInteger)index{
    if(_index == 0){
        _preLabel.text = @"无";
        _nextLabel.text = @"下一题";
    }else if(_index == [_questions count] -1){
        _preLabel.text = @"上一题";
        _nextLabel.text = @"无";
    }else{
        _preLabel.text = @"上一题";
        _nextLabel.text = @"下一题";
    }
    self.title = [NSString stringWithFormat:@"%ld/%ld",index+1,[_questions count]];
}

#pragma mark - 共有方法

- (void)updateData:(ExerciseMode)mode type:(ExerciseType)type chapter:(NSInteger)chapterIndex{
    _mode = mode;
    _type = type;
    _chapterIndex = chapterIndex;
}

#pragma mark - 自定义界面返回事件
- (void)popFromCurrentViewController{
    if([_judgedDic count] == [_questions count]){
        [super popFromCurrentViewController];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确认退出" message:@"当前练习未完成\ntips:已做错的题会保存在错题集" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        UIAlertAction *back = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [super popFromCurrentViewController];
        }];
        [alert addAction:back];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end