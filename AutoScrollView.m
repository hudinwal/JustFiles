//
//  AutoScrollView.m
//  AutoScrollViewSample
//
//  Created by Dinesh Kumar on 04/11/15.
//  Copyright © 2015 Infoedge India Pvt. Ltd. All rights reserved.
//

#import "AutoScrollView.h"

@interface AutoScrollView()
{
    NSMutableArray * _scrollContentSubviews;
}

@property (nonatomic,strong) NSLayoutConstraint * topConstraint;
@property (nonatomic,strong) NSLayoutConstraint * bottomConstraint;

@end

@implementation AutoScrollView

@synthesize scrollContentSubviews = _scrollContentSubviews;

-(void)setScrollContentSubviews:(NSArray *)scrollContentSubviews {
    if(!_scrollContentSubviews)
        _scrollContentSubviews = [NSMutableArray new];
    
    for (UIView * view in scrollContentSubviews) {
        [self insertContentSubview:view];
    }
}

-(void)insertContentSubview:(UIView *)contentSubview {
    [self insertContentSubview:contentSubview atIndex:_scrollContentSubviews.count];
}

-(void)insertContentSubview:(UIView *)contentSubview atIndex:(NSUInteger)index {
    if(!contentSubview || index > _scrollContentSubviews.count)return;

    if(index == 0)
        [self addView:contentSubview
            belowView:_contentView
            aboveView:_scrollContentSubviews.count>0?_scrollContentSubviews[0]:_contentView];
    
    else if(index==_scrollContentSubviews.count)
        [self addView:contentSubview
            belowView:_scrollContentSubviews[index-1]
            aboveView:_contentView];
    else
        [self addView:contentSubview
            belowView:_scrollContentSubviews[index-1]
            aboveView:_scrollContentSubviews[index]];
}

//-----------------------------------------------------------------//
#pragma mark - Constraining Views
//-----------------------------------------------------------------//

-(void)addView:(UIView *)view belowView:(UIView *)viewAbove aboveView:(UIView *)viewBelow {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:view];
    CGSize compressedSize = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [view setFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), compressedSize.height)];
    
    
    NSArray * defaultConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
    NSLayoutConstraint * upperConstraint,* lowerConstraint;
    
    if(viewAbove==_contentView) {
        [_contentView removeConstraint:_topConstraint];
        upperConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)].firstObject;
        _topConstraint = upperConstraint;
    }
    else
        upperConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewAbove]-0-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view,viewAbove)].firstObject;
    
    if(viewBelow==_contentView) {
        [_contentView removeConstraint:_bottomConstraint];
        lowerConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)].firstObject;
        _bottomConstraint = lowerConstraint;
    }
    else
        lowerConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-[viewBelow]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view,viewBelow)].firstObject;
    
    [_contentView addConstraints:defaultConstraints];
    [_contentView addConstraints:@[upperConstraint,lowerConstraint]];
    
    [_scrollContentSubviews addObject:view];
}

@end
