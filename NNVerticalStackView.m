//
//  NNVerticalStackView.m
//
//  Created by Dinesh Kumar on 04/11/15.
//  Copyright © 2015 Infoedge India Pvt. Ltd. All rights reserved.
//

#import "NNVerticalStackView.h"

CGFloat const NNStackViewContentHeightMetric = -1;

@interface NNVerticalStackView() {
    NSMutableArray * _stackViewItems;
}

@property (nonatomic,strong) NSLayoutConstraint * topConstraint;
@property (nonatomic,strong) NSLayoutConstraint * bottomConstraint;

@end

@implementation NNVerticalStackView

@synthesize stackViewItems = _stackViewItems;

//-----------------------------------------------------------------//
#pragma mark - Init Methods
//-----------------------------------------------------------------//

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
        _stackViewItems = [NSMutableArray new];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
        _stackViewItems = [NSMutableArray new];
    return self;
}

//-----------------------------------------------------------------//
#pragma mark - Public Methods
//-----------------------------------------------------------------//

-(void)setStackViewItems:(NSArray *)stackViewItems {
    _stackViewItems = [NSMutableArray new];
    for (UIView * view in stackViewItems) {
        [self insertStackItem:view];
    }
}


-(void)insertStackItem:(UIView *)stackItem {
    [self insertStackItem:stackItem atIndex:_stackViewItems.count withItemHeight:NNStackViewContentHeightMetric];
}

-(void)insertStackItem:(UIView *)stackItem withItemHeight:(CGFloat)height {
    [self insertStackItem:stackItem atIndex:_stackViewItems.count withItemHeight:height];
}

-(void)insertStackItem:(UIView *)stackItem
               atIndex:(NSUInteger)index
{
    [self insertStackItem:stackItem atIndex:index withItemHeight:NNStackViewContentHeightMetric];
}


-(void)insertStackItem:(UIView *)stackItem
               atIndex:(NSUInteger)index
        withItemHeight:(CGFloat)height {
    if(!stackItem || index > _stackViewItems.count)return;
    
    if(index == 0)
        [self addView:stackItem
            belowView:self
            aboveView:(_stackViewItems.count>0?_stackViewItems.firstObject:self)
           withHeight:height];
    
    else if(index==_stackViewItems.count)
        [self addView:stackItem
            belowView:_stackViewItems[index-1]
            aboveView:self
           withHeight:height];
    else
        [self addView:stackItem
            belowView:_stackViewItems[index-1]
            aboveView:_stackViewItems[index]
           withHeight:height];
    
    [_stackViewItems insertObject:stackItem atIndex:index];
}

-(void)removeStackItem:(UIView *)stackItem
{
    NSUInteger index = [self.stackViewItems indexOfObject:stackItem];
    if(index == NSNotFound) return;
    [self removeStackItemAtIndex:index];
}

-(void)removeStackItemAtIndex:(NSUInteger)index
{
    if(self.stackViewItems.count <= index) return;
    UIView * viewToRemove = self.stackViewItems[index];
    UIView * viewAbove = nil;
    UIView * viewBelow = nil;
    if(index > 0)
        viewAbove = self.stackViewItems[index-1];
    if(index < self.stackViewItems.count-1)
        viewBelow = self.stackViewItems[index+1];
    [self removeView:viewToRemove lyingBelowView:viewAbove lyingAboveView:viewBelow];
}

-(void)removeAllStackItems
{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

-(void)removeView:(UIView *)view lyingBelowView:(UIView *)viewAbove lyingAboveView:(UIView *)belowView {
    
    if(view.superview != self) return;
    
    [view removeFromSuperview];
    [_stackViewItems removeObject:view];
    
    if(viewAbove && !belowView)
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewAbove]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewAbove)]];
    if(!viewAbove && belowView)
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[belowView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(belowView)]];
    if(viewAbove && belowView)
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewAbove]-[belowView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewAbove,belowView)]];
}

//-----------------------------------------------------------------//
#pragma mark - Constraining Views
//-----------------------------------------------------------------//

-(void)addView:(UIView *)view
     belowView:(UIView *)viewAbove
     aboveView:(UIView *)viewBelow
    withHeight:(CGFloat)height{
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    if(height != NNStackViewContentHeightMetric && height > 0) {
        NSArray * heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(height)]" options:0 metrics:@{@"height":@(height)} views:NSDictionaryOfVariableBindings(view)];
        [view addConstraint:heightConstraint.firstObject];
    }
    
    NSArray * defaultConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
    NSLayoutConstraint * upperConstraint,* lowerConstraint;
    
    if(viewAbove==self) {
        [self removeConstraint:_topConstraint];
        upperConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)].firstObject;
        _topConstraint = upperConstraint;
    }
    else
        upperConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewAbove]-0-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view,viewAbove)].firstObject;
    
    if(viewBelow==self) {
        [self removeConstraint:_bottomConstraint];
        lowerConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)].firstObject;
        _bottomConstraint = lowerConstraint;
    }
    else
        lowerConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-[viewBelow]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view,viewBelow)].firstObject;
    
    [self addConstraints:defaultConstraints];
    [self addConstraints:@[upperConstraint,lowerConstraint]];
}

@end

//-----------------------------------------------------------------//
#pragma mark Alternate Coloring Of The vertical stack Items
//-----------------------------------------------------------------//

#define VIEW_BACKGROUND_COLOR [UIColor colorWithRed:245.f/255 green:247.f/255 blue:250.f/255 alpha:1.f]

@implementation NNVerticalStackView(NNVerticalStackColoring)

-(void)insertStackItemWithColouredBackground:(UIView *)stackItem{
    
    if (_stackViewItems.count % 2 != 0)
        stackItem.backgroundColor = VIEW_BACKGROUND_COLOR;
    else
        stackItem.backgroundColor = [UIColor whiteColor];
    
    [self insertStackItem:stackItem atIndex:_stackViewItems.count withItemHeight:NNStackViewContentHeightMetric];
}

@end
