//
//  BublesView.m
//  BubleLabel
//
//  Created by Anton Savinov on 27/02/2018.
//  Copyright © 2018 Anton Savinov. All rights reserved.
//

#import "BublesView.h"

static const CGFloat kDefaultBubleHeight = 30;

static const CGFloat kDefaultBubleHorizontalPadding = 20;
static const CGFloat kDefaultBubleVerticalPadding = 10;
static const CGFloat kDefaultBubleTitleLabelLeftPadding = 4;

static const NSUInteger kMaxNumberBublesInRow = 4;

static const CGFloat kBubleCornerRadius = 5.f;

static const CGFloat kMinFontSize = 10;

NSString * kBublesViewBackgroundColor = @"kBublesViewBackgroundColor";
NSString * kBubleViewBackgroundColor = @"kBubleViewBackgroundColor";
NSString * kBubleViewFont = @"kBubleViewFont";
NSString * kBubleViewFontColor = @"kBubleViewFontColor";
NSString * kBubleViewTouchedBackgroundColor = @"kBubleViewTouchedBackgroundColor";
NSString * kBubleViewTouchedFontColor = @"kBubleViewTouchedFontColor";

@interface BublesView ()

@property (strong, nonatomic) UIView *bublesView;

@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSArray<NSString *> *titles;

@end

@implementation BublesView

#pragma mark - Lyfe Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generalInitialization];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self generalInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self generalInitialization];
    }
    return self;
}

#pragma mark - Public

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
}

- (void)setUIAttributes:(NSDictionary*)attributes {
    if (!attributes) {
        return;
    }

    self.attributes = attributes;
}

- (void)apply {
    if (_bublesView) {
        [_bublesView removeFromSuperview];
        _bublesView = nil;
    }

    _bublesView = [[UIView alloc] initWithFrame:CGRectZero];

    NSUInteger inputCount = self.titles.count;
    NSUInteger requiredRowsCount = ceil((CGFloat)inputCount/(CGFloat)kMaxNumberBublesInRow);

    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);

    CGFloat yStartPoint = kDefaultBubleVerticalPadding / 2;

    UIFont *standartFont = [self bubleViewFont];

    for (NSUInteger row = 0; row < requiredRowsCount; row++) {

        NSUInteger bublesInRow = inputCount < kMaxNumberBublesInRow ? inputCount : kMaxNumberBublesInRow;

        CGFloat bubleWidthWithLeftPadding = screenWidth / bublesInRow;
        CGFloat calculatedBubleWidth = round(bubleWidthWithLeftPadding - kDefaultBubleHorizontalPadding);

        UIButton* lastButton;

        CGFloat xStartPoint = kDefaultBubleHorizontalPadding/2;

        for (NSUInteger column = 0; column < bublesInRow; column++) {

            UIButton *bubleButton= [UIButton buttonWithType:UIButtonTypeCustom];
            bubleButton.tag = column + row*kMaxNumberBublesInRow;
            [bubleButton addTarget:self action:@selector(bublePressed:) forControlEvents:UIControlEventTouchUpInside];
            [bubleButton addTarget:self action:@selector(bubleTouchDown:) forControlEvents:UIControlEventTouchDown];
            [bubleButton addTarget:self action:@selector(bubleDraggedOutside:) forControlEvents:UIControlEventTouchDragOutside];

            bubleButton.backgroundColor = [self bubleViewBackgroundColor];
            [bubleButton setTitle:self.titles[column + row*kMaxNumberBublesInRow] forState:UIControlStateNormal];
            bubleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            bubleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            bubleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);

            CGRect rect = CGRectMake(xStartPoint, yStartPoint, calculatedBubleWidth, kDefaultBubleHeight);
            bubleButton.frame = CGRectIntegral(rect);
            bubleButton.layer.cornerRadius = kBubleCornerRadius;
            bubleButton.layer.masksToBounds = YES;

            bubleButton.titleLabel.font = standartFont;
            [bubleButton setTitleColor:[self bubleViewFontColor] forState:UIControlStateNormal];
            [self fitFontForButtonIfNeeded:bubleButton];

            [_bublesView addSubview:bubleButton];

            xStartPoint = xStartPoint + CGRectGetWidth(bubleButton.bounds) + kDefaultBubleHorizontalPadding;

            lastButton = bubleButton;
        }
        yStartPoint = yStartPoint + CGRectGetHeight(lastButton.bounds) + kDefaultBubleVerticalPadding/2;

        inputCount -= kMaxNumberBublesInRow;
    }

    CGRect bublesFrame = CGRectMake(0, 0, screenWidth, yStartPoint);
    _bublesView.frame = bublesFrame;
    _bublesView.backgroundColor = [self bublesViewBackgroundColor];

    [self addSubview:_bublesView];
}

- (CGFloat)bublesViewHeight {
    return CGRectGetHeight(self.bounds);
}

#pragma mark - Selectors

- (void)bublePressed:(UIButton*)pressedBubble {

    pressedBubble.backgroundColor = [self bubleViewBackgroundColor];
    [pressedBubble setTitleColor:[self bubleViewFontColor] forState:UIControlStateNormal];

    if ([self.delegate respondsToSelector:@selector(bubleTappedByIndex:)]) {
        [self.delegate bubleTappedByIndex:pressedBubble.tag];
    }
}

- (void)bubleTouchDown:(UIButton*)touchedBubble {
    if ([touchedBubble.backgroundColor isEqual:[UIColor blackColor]]) {
        return;
    }
    touchedBubble.backgroundColor = [self bubleViewTouchedBackgroundColor];
    [touchedBubble setTitleColor:[self bubleViewTouchedFontColor] forState:UIControlStateNormal];
}

- (void)bubleDraggedOutside:(UIButton*)bubleDraggedOutside {
    bubleDraggedOutside.backgroundColor = [self bubleViewBackgroundColor];
    [bubleDraggedOutside setTitleColor:[self bubleViewFontColor] forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)generalInitialization {
}

- (UIColor*)bublesViewBackgroundColor {
    return self.attributes[kBublesViewBackgroundColor] ? self.attributes[kBublesViewBackgroundColor] : [UIColor blackColor];
}

- (UIColor*)bubleViewBackgroundColor {
    return self.attributes[kBubleViewBackgroundColor] ? self.attributes[kBubleViewBackgroundColor] : [UIColor whiteColor];
}

- (UIFont*)bubleViewFont {
    return self.attributes[kBubleViewFont] ? self.attributes[kBubleViewFont] : [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
}

- (UIColor*)bubleViewFontColor {
    return self.attributes[kBubleViewFontColor] ? self.attributes[kBubleViewFontColor] : [UIColor blackColor];
}

- (UIColor*)bubleViewTouchedBackgroundColor {
    return self.attributes[kBubleViewTouchedBackgroundColor] ? self.attributes[kBubleViewTouchedBackgroundColor] : [UIColor blackColor];
}

- (UIColor*)bubleViewTouchedFontColor {
    return self.attributes[kBubleViewTouchedFontColor] ? self.attributes[kBubleViewTouchedFontColor] : [UIColor whiteColor];
}

- (void)fitFontForButtonIfNeeded:(UIButton*)button {

    CGFloat fontSize = button.titleLabel.font.pointSize;

    do {
        button.titleLabel.font = [UIFont fontWithName:button.titleLabel.font.fontName size:fontSize];

        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.font, NSFontAttributeName, nil];
        CGFloat width = [[[NSAttributedString alloc] initWithString:button.titleLabel.text attributes:attributes] size].width;

        if((width + 2*kDefaultBubleTitleLabelLeftPadding) <= CGRectGetWidth(button.frame)) {
            break;
        }

        fontSize -= 1.;

    } while (fontSize > kMinFontSize);

    button.titleLabel.font = [button.titleLabel.font fontWithSize:fontSize];
}

@end
