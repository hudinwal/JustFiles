//
//  IEScrollContentView.m
//
//  Created by Dinesh Kumar on 04/11/15.
//

#import "IEScrollContentView.h"

@interface IEScrollContentView()
{
    NSMutableArray * _stackViewItems;
}

@property (nonatomic,strong) NSLayoutConstraint * topConstraint;
@property (nonatomic,strong) NSLayoutConstraint * bottomConstraint;

@end

@implementation IEScrollContentView

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
    if(!_stackViewItems)
        _stackViewItems = [NSMutableArray new];
    
    for (UIView * view in stackViewItems) {
        [self insertStackItem:view];
    }
}

-(void)insertStackItem:(UIView *)stackItem
{
    [self insertStackItem:stackItem atIndex:_stackViewItems.count];
}

-(void)insertStackItem:(UIView *)stackItem atIndex:(NSUInteger)index
{
    if(!stackItem || index > _stackViewItems.count)return;
    
    if(index == 0)
        [self addView:stackItem
            belowView:self
            aboveView:_stackViewItems.count>0?_stackViewItems.firstObject:self];
    
    else if(index==_stackViewItems.count)
        [self addView:stackItem
            belowView:_stackViewItems[index-1]
            aboveView:self];
    else
        [self addView:stackItem
            belowView:_stackViewItems[index-1]
            aboveView:_stackViewItems[index]];
}

//-----------------------------------------------------------------//
#pragma mark - Constraining Views
//-----------------------------------------------------------------//

-(void)addView:(UIView *)view belowView:(UIView *)viewAbove aboveView:(UIView *)viewBelow {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
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
    
    [_stackViewItems addObject:view];
}

@end
