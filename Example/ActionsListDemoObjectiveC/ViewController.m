//
//  ActionsList
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import "ViewController.h"
@import ActionsList;

@interface ViewController ()

@end

@implementation ViewController {
    ActionsListModel* list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NULL];
    [self createBackground];
    [self createNavigationItems];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[[UIImage imageNamed:@"Clock app"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
            forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clockButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setAdjustsImageWhenHighlighted:NO];
    
    [self.view addSubview:button];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[button.heightAnchor constraintEqualToConstant:60] setActive:YES];
    [[button.widthAnchor constraintEqualToAnchor:button.heightAnchor] setActive:YES];
    
    [[button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-64] setActive:YES];
    [[button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-100] setActive:YES];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)createBackground {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wallpaper"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:imageView];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[imageView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[imageView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
}

- (void)createNavigationItems {
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [rightButton setTitle:@"Button" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(presentFromNavigation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setImage:[UIImage imageNamed:@"List icon"] forState:UIControlStateNormal];
    [rightButton1 setAdjustsImageWhenHighlighted:NO];
    [rightButton1 setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [rightButton1 setTintColor:UIColor.blackColor];
    [rightButton1 sizeToFit];
    [rightButton1 addTarget:self action:@selector(presentFromNavigation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:rightButton1],
                                                  [[UIBarButtonItem alloc] initWithCustomView:rightButton]]];
    
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List icon"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(presentFromNavigationBar:)],
                                                 [[UIBarButtonItem alloc] initWithTitle:@"BarButton"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(presentFromNavigationBar:)]]];
}

- (void)clockButtonAction:(UIButton*)sender {
    ActionsListModel* model = [sender createActionsListWithDelegate:NULL];
    
    [model addAction:[[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Create Alarm"
                                                                             image:[UIImage imageNamed:@"Alarm clock"]
                                                                            action:^(ActionsListDefaultButtonModel* model) {
                                                                                [model.list dismissWithCompletion:NULL];
                                                                            }
                                                                         isEnabled:YES]];
    
    [model addAction:[[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Start Stopwatch"
                                                                             image:[UIImage imageNamed:@"Stopwatch"]
                                                                            action:^(ActionsListDefaultButtonModel* model) {
                                                                                [model.list dismissWithCompletion:NULL];
                                                                            }
                                                                         isEnabled:YES]];
    
    [model addAction:[[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Start Timer"
                                                                             image:[UIImage imageNamed:@"Timer"]
                                                                            action:^(ActionsListDefaultButtonModel* model) {
                                                                                [model.list dismissWithCompletion:NULL];
                                                                            }
                                                                         isEnabled:YES]];
    
    [model presentWithCompletion:NULL];
    list = model;
}

- (void)presentFromNavigation:(UIButton*)button {
    ActionsListModel* model = [button createActionsListWithDelegate:NULL];
    
    [model addAction:[[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Test"
                                                                             image:[UIImage imageNamed:@"Dot"]
                                                                            action:^(ActionsListDefaultButtonModel* model) {
                                                                                [model.list dismissWithCompletion:^{
                                                                                    NSLog(@"Test");
                                                                                }];
                                                                            } isEnabled:YES]];
    
    ActionsListDefaultButtonModel* action2Model = [[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Test\nTest\nTest"
                                                                                                          image:[UIImage imageNamed:@"Dot"]
                                                                                                         action:^(ActionsListDefaultButtonModel* model) {
                                                                                                             [model.list dismissWithCompletion:^{
                                                                                                                 NSLog(@"Test");
                                                                                                             }];
                                                                                                         } isEnabled:YES];
    action2Model.appearance.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    action2Model.appearance.highlightedBackgroundColor = UIColor.redColor;
    action2Model.appearance.highlightedTint = UIColor.yellowColor;
    action2Model.appearance.tint = UIColor.blueColor;
    action2Model.appearance.backgroundColor = UIColor.brownColor;
    [model addAction:action2Model];
    
    model.appearance.blurBackgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    [model presentWithCompletion:NULL];
    list = model;
}

-(void)presentFromNavigationBar:(UIBarButtonItem*)barButton {
    ActionsListModel* model = [barButton createActionsListWithColor:[UIColor redColor]
                                                               font:NULL
                                                           delegate:NULL];
    
    [model addAction:[[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Test\nTest"
                                                                             image:[UIImage imageNamed:@"Dot"]
                                                                            action:^(ActionsListDefaultButtonModel* model) {
                                                                                [model.list dismissWithCompletion:^{
                                                                                    NSLog(@"Test");
                                                                                }];
                                                                            } isEnabled:YES]];
    
    [model addAction:[[ActionsListDefaultButtonModel alloc] initWithLocalizedTitle:@"Test\nTest\nTest\nTest"
                                                                                                          image:[UIImage imageNamed:@"Dot"]
                                                                                                         action:^(ActionsListDefaultButtonModel* model) {
                                                                                                             [model.list dismissWithCompletion:^{
                                                                                                                 NSLog(@"Test");
                                                                                                             }];
                                                                                                              } isEnabled:YES]];
                                                                                                             
    [model presentWithCompletion:NULL];
    list = model;
}

@end
