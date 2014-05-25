//
//  RKSCustomNavigationController.m
//  CustomNavbar
//
//  Created by Rahul on 4/19/14.
//
//

#import "RKSCustomNavigationController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FOOTER_HEIGHT 4
#define BACK_CONTINUE_BUTTON_HEIGHT 44
#define BACK_CONTINUE_BUTTON_POSITION_FROM_EDGES 5

@interface RKSCustomNavBar : UINavigationBar
@property (nonatomic) SEL leftBarButtonAction;
@property (nonatomic) SEL rightBarButtonAction;
@property (nonatomic) id target;
@property (nonatomic) BOOL showLeftBarButton;
@property (nonatomic) BOOL showRightBarButton;
@property (nonatomic) NSString *leftBarButtonTitle;
@property (nonatomic) NSString *rightBarButtonTitle;
@property (nonatomic, strong) UIBarButtonItem *leftNavBarButton;
@property (nonatomic, strong) UIBarButtonItem *rightNavBarButton;

- (void)enableDisableRightBarButtonState:(BOOL)enabled;
- (void)enableDisableLeftBarButtonState:(BOOL)enabled;
@end

@implementation RKSCustomNavBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake(self.frame.size.width,70);
    return newSize;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	
	
	self.translucent = YES;
	[self setBarTintColor:UIColorFromRGB(0x067AB5)];
	[self setTintColor:[UIColor yellowColor]];

	if (self.showLeftBarButton) {
		if (!self.leftNavBarButton) {
			UIButton *leftNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[leftNavBarButton setImage: [UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
			[leftNavBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
			[leftNavBarButton setFrame:CGRectMake(0, 0, 120, BACK_CONTINUE_BUTTON_HEIGHT)];
			leftNavBarButton.tintColor = self.tintColor;
			[leftNavBarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
			[leftNavBarButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
			[leftNavBarButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
			[leftNavBarButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
			[leftNavBarButton setTitle:(self.leftBarButtonTitle.length > 0 ? self.leftBarButtonTitle:@"Cancel") forState:UIControlStateNormal];
			[leftNavBarButton addTarget:self.target action:self.leftBarButtonAction forControlEvents:UIControlEventTouchUpInside];
			leftNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
			leftNavBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
			self.leftNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
		}
		self.topItem.leftBarButtonItem = self.leftNavBarButton;
	}
	
	if (self.showRightBarButton) {
		if (!self.rightNavBarButton) {
			UIButton *rightNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[rightNavBarButton setFrame:CGRectMake(0, 0, 120, BACK_CONTINUE_BUTTON_HEIGHT)];
			[rightNavBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
			[rightNavBarButton setTitle:(self.leftBarButtonTitle.length > 0 ? self.leftBarButtonTitle:@"Continue") forState:UIControlStateNormal];
			rightNavBarButton.tintColor = self.tintColor;
			[rightNavBarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
			[rightNavBarButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
			[rightNavBarButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
			[rightNavBarButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
			[rightNavBarButton addTarget:self.target action:self.rightBarButtonAction forControlEvents:UIControlEventTouchUpInside];
			rightNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
			rightNavBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
			self.rightNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
		}
		self.topItem.rightBarButtonItem = self.rightNavBarButton;
	}
	
	UIImage *navBarTitleImage = [UIImage imageNamed:@"appcoda-logo.png"];
	UIImageView *titleImageView = [[UIImageView alloc] initWithImage:navBarTitleImage];
	CGSize imageSize = navBarTitleImage.size;
	titleImageView.frame = CGRectMake((self.bounds.origin.x + self.bounds.size.width - imageSize.width)/2, (self.bounds.origin.y + self.bounds.size.height - imageSize.height - FOOTER_HEIGHT)/2, imageSize.width, imageSize.height);
	
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.origin.y + self.bounds.size.height - FOOTER_HEIGHT, self.bounds.size.width, FOOTER_HEIGHT)];
	[footerView setBackgroundColor:[UIColor orangeColor]];

	[self addSubview:titleImageView];
	[self addSubview:footerView];
	
	UINavigationItem *navigationItem = [self topItem];
	
    for (UIView *subview in [self subviews]) {
        if (subview == [[navigationItem rightBarButtonItem] customView]) {
            CGRect newRightButtonRect = CGRectMake((self.bounds.origin.x + self.bounds.size.width - subview.frame.size.width - BACK_CONTINUE_BUTTON_POSITION_FROM_EDGES),
												   (self.bounds.origin.y + self.bounds.size.height - subview.frame.size.height - FOOTER_HEIGHT)/2,
                                                   subview.frame.size.width,
                                                   subview.frame.size.height);
            [subview setFrame:newRightButtonRect];
        } else if (subview == [[navigationItem leftBarButtonItem] customView]) {
            CGRect newLeftButtonRect = CGRectMake(BACK_CONTINUE_BUTTON_POSITION_FROM_EDGES,
                                                  (self.bounds.origin.y + self.bounds.size.height - subview.frame.size.height - FOOTER_HEIGHT)/2,
                                                  subview.frame.size.width,
                                                  subview.frame.size.height);
            [subview setFrame:newLeftButtonRect];
        }
    }
}

- (void)enableDisableRightBarButtonState:(BOOL)enabled {
	UINavigationItem *navigationItem = [self topItem];
	navigationItem.rightBarButtonItem.enabled = !navigationItem.rightBarButtonItem.enabled;
	UIButton *aButton = (UIButton *)[[navigationItem rightBarButtonItem] customView];
	[aButton setEnabled:navigationItem.rightBarButtonItem.enabled];
	
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
}
- (void)enableDisableLeftBarButtonState:(BOOL)enabled {
	UINavigationItem *navigationItem = [self topItem];
	navigationItem.leftBarButtonItem.enabled = !navigationItem.leftBarButtonItem.enabled;
	UIButton *aButton = (UIButton *)[[navigationItem leftBarButtonItem] customView];
	[aButton setEnabled:navigationItem.leftBarButtonItem.enabled];
	
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
}


@end


@interface RKSCustomNavigationController ()
@end

@implementation RKSCustomNavigationController

- (instancetype)init {
    self = [self initWithNavigationBarClass:[RKSCustomNavBar class] toolbarClass:[UIToolbar class]];
    if (self) {
        ;
    }
    return self;
}

- (void) viewWillLayoutSubviews {
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	RKSCustomNavBar *navBar = (RKSCustomNavBar*)self.navigationBar;
	navBar.leftBarButtonAction = @selector(leftBarButtonAction);
	navBar.rightBarButtonAction = @selector(rightBarButtonAction);
	navBar.target = self;
	navBar.showLeftBarButton = (self.viewControllers.count > 1);
	navBar.showRightBarButton = YES;
}

- (void) leftBarButtonAction {
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	if (self.viewControllers.count > 1) {
		[self popViewControllerAnimated:YES];
	} else {
		[self dismissViewControllerAnimated:YES completion:^{
			;
		}];
	}
}

- (void) rightBarButtonAction {
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
}

- (void)enableDisableRightBarButtonState:(BOOL)enabled {
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	RKSCustomNavBar *navBar = (RKSCustomNavBar*)self.navigationBar;
	[navBar enableDisableRightBarButtonState:enabled];
}
- (void)enableDisableLeftBarButtonState:(BOOL)enabled {
	NSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	RKSCustomNavBar *navBar = (RKSCustomNavBar*)self.navigationBar;
	[navBar enableDisableLeftBarButtonState:enabled];
}


@end
