//
//  BublesView.h
//  BubleLabel
//
//  Created by Anton Savinov on 27/02/2018.
//  Copyright © 2018 Anton Savinov. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSString * kBublesViewBackgroundColor;
extern const NSString * kBubleViewBackgroundColor;
extern const NSString * kBubleViewFont;
extern const NSString * kBubleViewFontColor;
extern const NSString * kBubleViewTouchedBackgroundColor;
extern const NSString * kBubleViewTouchedFontColor;

@protocol BublesViewDelegate;

@interface BublesView : UIView

@property (weak, nonatomic) id <BublesViewDelegate> delegate;

- (void)setTitles:(NSArray<NSString*>*)titles;
- (void)setUIAttributes:(NSDictionary*)attributes;
- (void)apply;

- (CGFloat)bublesViewHeight;

@end

@protocol BublesViewDelegate <NSObject>

@optional
- (void)bubleTappedByIndex:(NSUInteger)index;

@end
