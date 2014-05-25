//
//  RKSCustomNavigationViewController.m
//  CustomNavbar
//
//  Created by Rahul on 4/19/14.
//
//

#import "RKSCustomNavigationViewController.h"

#if defined(DEBUG) || TARGET_IPHONE_SIMULATOR
#   define RKSLog(...) NSLog(__VA_ARGS__)
#else
#   define RKSLog(...)
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FOOTER_HEIGHT 4
#define BACK_CONTINUE_BUTTON_HEIGHT 44
#define NAV_BAR_HEIGHT 120
#define BACK_CONTINUE_BUTTON_POSITION_FROM_EDGES 5

@class RKSCustomNavBar, RKSCustomNavigationController;

#pragma mark - Protocols -

/**
 *
 This protocol will help decide what and how should the controls be placed on the nav bar.
 *
 */
@protocol RKSCustomNavBarProtocol <NSObject>

@required
/* Title of the left nav bar item. */
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar titleOfLeftItem:(UIBarButtonItem *)item;
/* Title of the right nav bar item. */
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar titleOfRightItem:(UIBarButtonItem *)item;
/* What action to perform when left nav bar button item is tapped. */
- (void) navigationBar:(RKSCustomNavBar *)navBar didTapLeftItem:(UIBarButtonItem *)item;
/* What action to perform when right nav bar button item is tapped. */
- (void) navigationBar:(RKSCustomNavBar *)navBar didTapRightItem:(UIBarButtonItem *)item;

// Accessibility Hint for Nav Bar buttons
/* Accessibility for left nav bar button item. */
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar accessibilityHintOfLeftItem:(UIBarButtonItem *)item;
/* Accessibility for right nav bar button item. */
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar accessibilityHintOfRightItem:(UIBarButtonItem *)item;

@end

@protocol RKSCustomNavigationControllerProtocol <RKSCustomNavBarProtocol>

@end


#pragma mark - Custom Navigation Bar -

@interface RKSCustomNavBar : UINavigationBar
@property (nonatomic) id<RKSCustomNavBarProtocol> customDelegate;
@property (nonatomic) BOOL showLeftBarButton;
@property (nonatomic) BOOL showRightBarButton;
@property (nonatomic, strong) UIBarButtonItem *leftNavBarButton;
@property (nonatomic, strong) UIBarButtonItem *rightNavBarButton;
@property (nonatomic, strong) UIButton *leftNavButton;
@property (nonatomic, strong) UIButton *rightNavButton;

- (void)enableDisableRightBarButtonState:(BOOL)enabled;
- (void)enableDisableLeftBarButtonState:(BOOL)enabled;
@end

@implementation RKSCustomNavBar

/* Override this method to let iOS know that for this view controller, we are going to show a nav bar of this height. */
- (CGSize)sizeThatFits:(CGSize)size { return CGSizeMake(self.frame.size.width, NAV_BAR_HEIGHT); }

/* Override this method to ACTUALLY override the nav bar and show custom controls as we desire. */
- (void) layoutSubviews {
	[super layoutSubviews];
	RKSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	
	self.translucent = YES;
	[self setBarTintColor:UIColorFromRGB(0x067AB5)];
	[self setTintColor:[UIColor yellowColor]];
	
	if (self.showLeftBarButton) {
		if (!self.leftNavButton) {
			UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[leftButton setImage: [UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
			[leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
			[leftButton setFrame:CGRectMake(0, 0, 120, BACK_CONTINUE_BUTTON_HEIGHT)];
			leftButton.tintColor = self.tintColor;
			[leftButton setTitleColor:self.tintColor forState:UIControlStateNormal];
			[leftButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
			[leftButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
			[leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
			[leftButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
			leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
			leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
			
			self.leftNavButton = leftButton;
		}
		if (!self.leftNavBarButton) {
			self.leftNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.leftNavButton];
		}
		
		// Update Left Bar Button's title
		NSString *buttonTitle = @"Cancel";
		if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(navigationBar:accessibilityHintOfLeftItem:)]) {
			self.leftNavButton.accessibilityHint = [self.customDelegate navigationBar:self accessibilityHintOfLeftItem:self.topItem.leftBarButtonItem];
		}
		if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(navigationBar:titleOfLeftItem:)]) {
			buttonTitle = [self.customDelegate navigationBar:self titleOfLeftItem:self.topItem.leftBarButtonItem];
		}
		
		[self.leftNavButton setTitle:buttonTitle forState:UIControlStateNormal];
		[self.leftNavButton setNeedsLayout];			// Button might not be updated, set the flag to reflect the change.
		self.topItem.leftBarButtonItem = self.leftNavBarButton;
	}
	
	if (self.showRightBarButton) {
		if (!self.rightNavButton) {
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[rightButton setFrame:CGRectMake(0, 0, 120, BACK_CONTINUE_BUTTON_HEIGHT)];
			[rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
			rightButton.tintColor = self.tintColor;
			[rightButton setTitleColor:self.tintColor forState:UIControlStateNormal];
			[rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
			[rightButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
			[rightButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
			[rightButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
			rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
			rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
			
			self.rightNavButton = rightButton;
		}
		if (!self.rightNavBarButton) {
			self.rightNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
		}
		
		// Update Right Bar Button's title
		NSString *buttonTitle = @"Continue";
		if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(navigationBar:accessibilityHintOfRightItem:)]) {
			self.rightNavButton.accessibilityHint = [self.customDelegate navigationBar:self accessibilityHintOfRightItem:self.topItem.rightBarButtonItem];
		}
		if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(navigationBar:titleOfRightItem:)]) {
			buttonTitle = [self.customDelegate navigationBar:self titleOfRightItem:self.topItem.rightBarButtonItem];
		}
		
		[self.rightNavButton setTitle:buttonTitle forState:UIControlStateNormal];
		[self.rightNavButton setNeedsLayout];			// Button might not be updated, set the flag to reflect the change.
		self.topItem.rightBarButtonItem = self.rightNavBarButton;
	}
	
	
	UIImage *navBarTitleImage = [UIImage imageNamed:@"bat.png"];
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
	navigationItem.rightBarButtonItem.enabled = enabled;
	UIButton *aButton = (UIButton *)[[navigationItem rightBarButtonItem] customView];
	[aButton setEnabled:enabled];
}
- (void)enableDisableLeftBarButtonState:(BOOL)enabled {
	UINavigationItem *navigationItem = [self topItem];
	navigationItem.leftBarButtonItem.enabled = enabled;
	UIButton *aButton = (UIButton *)[[navigationItem leftBarButtonItem] customView];
	[aButton setEnabled:enabled];
}


- (void) leftBarButtonItemAction {
	if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(navigationBar:didTapLeftItem:)]) {
		[self.customDelegate navigationBar:self didTapLeftItem:self.topItem.leftBarButtonItem];
	}
}
- (void) rightBarButtonItemAction {
	if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(navigationBar:didTapRightItem:)]) {
		[self.customDelegate navigationBar:self didTapRightItem:self.topItem.rightBarButtonItem];
	}
}

@end


#pragma mark - Custom Navigation Controller -

@interface RKSCustomNavigationController : UINavigationController

- (void)setCustomNavigationDelegate:(id<RKSCustomNavigationControllerProtocol>)delegate;
- (void)enableDisableRightBarButtonState:(BOOL)enabled;
- (void)enableDisableLeftBarButtonState:(BOOL)enabled;
- (void)showHideRightBarButton:(BOOL)showHide;
- (void)showHideLeftBarButton:(BOOL)showHide;

@end

@implementation RKSCustomNavigationController

- (instancetype)init {
    self = [self initWithNavigationBarClass:[RKSCustomNavBar class] toolbarClass:[UIToolbar class]];
    if (self) {
        ;
    }
    return self;
}

#pragma mark - Methods to be shipped to the navigation controller -

- (void) viewWillLayoutSubviews {
	RKSLog(@"Inside %@ -> %@", [self class], NSStringFromSelector(_cmd));
	RKSCustomNavBar *navBar = (RKSCustomNavBar *)self.navigationBar;
	navBar.showLeftBarButton = (self.viewControllers.count > 1);
	navBar.showRightBarButton = YES;
	
	// Exclusively update the layout, we need this to reflect the titles and set behaviour correctly
	[navBar setNeedsLayout];
}
- (void)enableDisableRightBarButtonState:(BOOL)enabled {
	RKSCustomNavBar *navBar = (RKSCustomNavBar *)self.navigationBar;
	[navBar enableDisableRightBarButtonState:enabled];
}
- (void)enableDisableLeftBarButtonState:(BOOL)enabled {
	RKSCustomNavBar *navBar = (RKSCustomNavBar *)self.navigationBar;
	[navBar enableDisableLeftBarButtonState:enabled];
}
- (void)showHideRightBarButton:(BOOL)showHide {
	RKSCustomNavBar *navBar = (RKSCustomNavBar *)self.navigationBar;
	navBar.showRightBarButton = showHide;
}
- (void)showHideLeftBarButton:(BOOL)showHide {
	RKSCustomNavBar *navBar = (RKSCustomNavBar *)self.navigationBar;
	navBar.showLeftBarButton = showHide;
}
- (void) setCustomNavigationDelegate:(id<RKSCustomNavigationControllerProtocol>)delegate {
	RKSCustomNavBar *navBar = (RKSCustomNavBar *)self.navigationBar;
	navBar.customDelegate = delegate;
}


@end

#pragma mark - BaseView Controller -

@interface RKSCustomNavigationViewController () <RKSCustomNavigationControllerProtocol>

@property (nonatomic) BOOL enableRightNavBarButton;
@property (nonatomic) BOOL enableLeftNavBarButton;
@property (nonatomic) BOOL showRightNavBarButton;
@property (nonatomic) BOOL showLeftNavBarButton;
@property (nonatomic, strong) NSString *leftNavButtonTitle;
@property (nonatomic, strong) NSString *rightNavButtonTitle;
@property (nonatomic, strong) NSString *leftNavButtonAccessibilityHint;
@property (nonatomic, strong) NSString *rightNavButtonAccessibilityHint;

@end

@implementation RKSCustomNavigationViewController

@synthesize enableLeftNavBarButton = _enableLeftNavBarButton, enableRightNavBarButton = _enableRightNavBarButton, showLeftNavBarButton = _showLeftNavBarButton, showRightNavBarButton = _showRightNavBarButton;

- (IBAction)dismissModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		;
	}];
}
- (IBAction)reloadSameVC:(id)sender {
	[self.navigationController pushViewController:[[RKSCustomNavigationViewController alloc] initWithNibName:@"RKSCustomNavigationViewController" bundle:nil] animated:YES];
}
- (IBAction)enableDisableRightBarButtonState:(id)sender {
	self.enableRightNavBarButton = !self.enableRightNavBarButton;
}
- (IBAction)enableDisableLeftBarButtonState:(id)sender {
	self.enableLeftNavBarButton = !self.enableLeftNavBarButton;
}


#pragma mark - Methods to be shipped to the base view controller -

- (void) viewWillLayoutSubviews {
	RKSLog(@"Inside%lu %@ -> %@", (unsigned long)self.navigationController.viewControllers.count, [self class], NSStringFromSelector(_cmd));
	[super viewWillLayoutSubviews];
	[(RKSCustomNavigationController *)self.navigationController setCustomNavigationDelegate:self];
	
	// Set enable / disable nav bar button flags here
	self.enableRightNavBarButton = NO;
	self.showRightNavBarButton = YES;
	self.enableLeftNavBarButton = YES;
	self.showLeftNavBarButton = (self.navigationController.viewControllers.count > 1);
	self.leftNavButtonTitle = [NSString stringWithFormat:@"Cancel%lu", (unsigned long)self.navigationController.viewControllers.count];
	self.rightNavButtonTitle = [NSString stringWithFormat:@"Continue%lu", (unsigned long)self.navigationController.viewControllers.count];
	self.leftNavButtonAccessibilityHint = @"Double tap to go back to previous screen.";
	self.rightNavButtonAccessibilityHint = @"Double tap to proceed.";
}

- (void) leftBarButtonAction {
	RKSLog(@"Inside%lu %@ -> %@", (unsigned long)self.navigationController.viewControllers.count, [self class], NSStringFromSelector(_cmd));
	if (self.navigationController.viewControllers.count > 1) {
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		[self dismissModal:nil];
	}
}
- (void) rightBarButtonAction {
	RKSLog
	(@"Inside%lu %@ -> %@", (unsigned long)self.navigationController.viewControllers.count, [self class], NSStringFromSelector(_cmd));
	[self reloadSameVC:nil];
}
// Enable / Disable Nav Bar Buttons
- (BOOL) enableLeftNavBarButton { return _enableLeftNavBarButton; }
- (BOOL) enableRightNavBarButton { return _enableRightNavBarButton; }
- (void) setEnableLeftNavBarButton:(BOOL)enableLeftNavBarButton {
	_enableLeftNavBarButton = enableLeftNavBarButton;
	[(RKSCustomNavigationController *)self.navigationController enableDisableLeftBarButtonState:enableLeftNavBarButton];
}
- (void) setEnableRightNavBarButton:(BOOL)enableRightNavBarButton {
	_enableRightNavBarButton = enableRightNavBarButton;
	[(RKSCustomNavigationController *)self.navigationController enableDisableRightBarButtonState:enableRightNavBarButton];
}
// Show / Hide Nav Bar Buttons
- (BOOL) showLeftNavBarButton { return _showLeftNavBarButton; }
- (BOOL) showRightNavBarButton { return _showRightNavBarButton; }
- (void) setShowLeftNavBarButton:(BOOL)showLeftNavBarButton {
	_showLeftNavBarButton = showLeftNavBarButton;
	[(RKSCustomNavigationController *)self.navigationController showHideLeftBarButton:showLeftNavBarButton];
}
- (void) setShowRightNavBarButton:(BOOL)showRightNavBarButton {
	_showRightNavBarButton = showRightNavBarButton;
	[(RKSCustomNavigationController *)self.navigationController showHideRightBarButton:showRightNavBarButton];
}


#pragma mark - Nav Bar Delegates -

- (void) navigationBar:(RKSCustomNavBar *)navBar didTapLeftItem:(UIBarButtonItem *)item { [self leftBarButtonAction]; }
- (void) navigationBar:(RKSCustomNavBar *)navBar didTapRightItem:(UIBarButtonItem *)item { [self rightBarButtonAction]; }
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar titleOfLeftItem:(UIBarButtonItem *)item { return self.leftNavButtonTitle; }
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar titleOfRightItem:(UIBarButtonItem *)item { return self.rightNavButtonTitle; }
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar accessibilityHintOfLeftItem:(UIBarButtonItem *)item { return self.leftNavButtonAccessibilityHint; }
- (NSString *) navigationBar:(RKSCustomNavBar *)navBar accessibilityHintOfRightItem:(UIBarButtonItem *)item { return self.rightNavButtonAccessibilityHint; }

@end

