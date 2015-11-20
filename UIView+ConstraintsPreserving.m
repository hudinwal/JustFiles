//
//  UIView+ConstraintsPreserving.m
//  ConstraintsPreservingSample
//
//  Created by Dinesh Kumar on 20/11/15.
//  Copyright © 2015 Infoedge India Pvt. Ltd. All rights reserved.
//

#import "UIView+ConstraintsPreserving.h"
#import <objc/runtime.h>

@implementation UIView (ConstraintsPreserving)

@dynamic preservedConstraints;

-(void)setPreservedConstraints:(NSMutableArray *)object {
    objc_setAssociatedObject(self, @selector(preservedConstraints), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)preservedConstraints {
    return objc_getAssociatedObject(self, @selector(preservedConstraints));
}

-(void)removeFromSuperViewPreservingConstriants
{
    if(!self.superview) return;
    
    self.preservedConstraints = [NSMutableArray new];
    [self.preservedConstraints addObjectsFromArray:[self constraints]];
    
    for (NSLayoutConstraint * constraint in self.superview.constraints) {
        if([constraint.firstItem isEqual:self] || [constraint.secondItem isEqual:self])
            [self.preservedConstraints addObject:constraint];
    }
    [self removeFromSuperview];
}

-(void)addSuperViewPreservingConstriants:(UIView *)superView
{
    if(self.superview) return;
    
    [superView addSubview:self];
    [superView addConstraints:self.preservedConstraints];
    self.preservedConstraints = nil;
}

@end
