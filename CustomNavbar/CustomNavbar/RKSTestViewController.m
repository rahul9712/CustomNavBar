//
//  RKSTestViewController.m
//  CustomNavbar
//
//  Created by Rahul on 4/19/14.
//
//

#import "RKSTestViewController.h"
#import "RKSCustomNavigationViewController.h"
#import "RKSCustomNavigationController.h"


@interface RKSTestViewController ()

@end

@implementation RKSTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadModalWithCustomNavBar:(id)sender {
	RKSCustomNavigationViewController *vc = [[RKSCustomNavigationViewController alloc] initWithNibName:@"RKSCustomNavigationViewController" bundle:nil];
	RKSCustomNavigationController *nav = [[RKSCustomNavigationController alloc]  init];
	[nav setViewControllers:@[vc]];
	
	[self presentViewController:nav animated:YES completion:^{
		;// Do something here?
	}];
}

@end
