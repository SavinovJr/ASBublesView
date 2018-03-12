# ASBublesView
ASBublesView is a small library which places views as bubles in your application.

# Setup
First implementation of ASBublesView support only CocoaPods. To integrate this UI library in your project, add the following line to your `Podfile`:

    pod 'ASBublesView', '~> 0.0.3'

Then run `pod install`.

# How to use it?
1. Add new UIView in any UIViewController and set up constraints. Don't forget to add constraint for height just created view.
```objc
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubleViewHeight;
```

2. For this UIView add class 'BublesView' in identity inspector.
3. Create `IBOutlet` for this view to your view controller:
```objc
@property (weak, nonatomic) IBOutlet BublesView *bublesView;
```

4. Inside source code your UIViewController import 
```objc 
#import <ASBublesView/BublesView.h>
```

5. Inside method `viewDidLoad` put the next piece of code:
```objc 
    ...
    //setting UI Attributes for BublesView
    //all keys to set up UI elements are available inside definition of "BublesView.h"
    [self.bublesView setUIAttributes:@{
                                       kBublesViewBackgroundColor: [UIColor colorWithRed:250./255. green:250./255. blue:250./255. alpha:1.],
                                       kBubleViewBackgroundColor: [UIColor colorWithRed:38./255. green:38./255. blue:38./255. alpha:1.],
                                       kBubleViewFont : [UIFont fontWithName:@"Helvetica-Bold" size:28],
                                       kBubleViewFontColor: [UIColor whiteColor],
                                       kBubleViewTouchedBackgroundColor: [UIColor darkGrayColor]
                                       }];

    //setting the main content
    self.dates = @[@"March, 1", @"March, 2", @"March, 3", @"March, 4", @"March, 5", @"March, 6", @"March, 7"];
    [self.bublesView setTitles:self.dates];

    //applying all parameters
    [self.bublesView apply];
    ...
```

6. After aplying these parameters you can use method
```objc 
  self.bubleViewHeight.constant = [self.bublesView bublesViewHeight];
```
for setting up correct height of bublesView

7. To understand which bubles was tapped add line inside method `viewDidLoad` or something else:
```objc
  ...
  self.bublesView.delegate = self;
  ...
```
and process method of 'BublesViewDelegate': 
```objc
- (void)bubleTappedByIndex:(NSUInteger)index {
  ...
}
```
