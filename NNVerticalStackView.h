//
//  NNVerticalStackView.h
//
//  Created by Dinesh Kumar on 04/11/15.
//  Copyright © 2015 Infoedge India Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const NNStackViewContentHeightMetric;

/**
 @author Dinesh  Kumar, 15-11-24
 
 A UIView subclass, that stacks its subviews vertically with autolyout enviornment.
 These stacks items or subviews provide the height to the view. Width of this
 view needs to be constrainted.
 */
@interface NNVerticalStackView : UIView

// Stack items(array of UIView). Uses content height of views. To set custom
// height for items use -insertStackItem:withItemHeight: on individual items.
@property (nonatomic,strong) NSArray * stackViewItems;

// Adds a stack item at the bottom of the stack, height if items is generated
// by its content
-(void)insertStackItem:(UIView *)stackItem;

-(void)insertStackItem:(UIView *)stackItem
               atIndex:(NSUInteger)index;

// Adds a stack item at the bottom of the stack with given height. In case height
// can be calculted by its content pass NNStackViewContentHeightMetric.
-(void)insertStackItem:(UIView *)stackItem withItemHeight:(CGFloat)height;

// Adds the stack items at the given index. In case height
// can be calculted by its content pass NNStackViewContentHeightMetric.
-(void)insertStackItem:(UIView *)stackItem
               atIndex:(NSUInteger)index
        withItemHeight:(CGFloat)height;


//-----------------------------------------------------------------//
#pragma mark Removal Methods
//-----------------------------------------------------------------//


-(void)removeStackItem:(UIView *)stackItem;
-(void)removeStackItemAtIndex:(NSUInteger)index;
-(void)removeAllStackItems;

@end

//-----------------------------------------------------------------//
#pragma mark - Alternate Coloring Of The vertical Stack Items
//-----------------------------------------------------------------//

@interface NNVerticalStackView (NNVerticalStackColoring)

// Adds a stack item at the bottom of the stack, height if items is generated
// by its content
// Add Background Color accordance of stackitem is added at Even or Odd index
-(void)insertStackItemWithColouredBackground:(UIView *)stackItem;


@end
