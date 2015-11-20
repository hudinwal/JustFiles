//
//  UIView+ConstraintsPreserving.h
//  ConstraintsPreservingSample
//
//  Created by Dinesh Kumar on 20/11/15.
//  Copyright © 2015 Infoedge India Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConstraintsPreserving)

@property (nonatomic, strong) NSMutableArray * preservedConstraints;

-(void)removeFromSuperViewPreservingConstriants;
-(void)addSuperViewPreservingConstriants:(UIView *)superView;

@end
