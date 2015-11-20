//
//  AutoScrollView.h
//  AutoScrollViewSample
//
//  Created by Dinesh Kumar on 04/11/15.
//  Copyright © 2015 Infoedge India Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AutoScrollView : UIScrollView

@property (nonatomic,strong) NSArray * scrollContentSubviews;
@property (nonatomic,strong) IBOutlet UIView * contentView;

-(void)insertContentSubview:(UIView *)contentSubview;
-(void)insertContentSubview:(UIView *)contentSubview atIndex:(NSUInteger)index;

@end
