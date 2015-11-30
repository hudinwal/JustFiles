//
//  IEScrollContentView.h
//
//  Created by Dinesh Kumar on 04/11/15.
//

#import <UIKit/UIKit.h>

/**
 @author Dinesh  Kumar, 15-11-24
 
 A UIView subclass, that stacks its subviews vertically with autolyout enviornment.
 These stacks items or subviews provide the height to the view. Width of this
 view needs to be constrainted.
 */
@interface IEScrollContentView : UIView

// Stack items(array of UIView)
@property (nonatomic,strong) NSArray * stackViewItems;

// Adds a stack item at the bottom of the stack
-(void)insertStackItem:(UIView *)stackItem;

//Adds the stack items at the given index
-(void)insertStackItem:(UIView *)stackItem atIndex:(NSUInteger)index;

@end
