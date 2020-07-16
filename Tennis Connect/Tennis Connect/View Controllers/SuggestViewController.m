//
//  SuggestViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/16/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "SuggestViewController.h"
#import "Court.h"

@interface SuggestViewController ()

@property (nonatomic, strong) NSMutableArray<Court*> *courts;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.courts = [defaults objectForKey:@"courts"];
    
    
}

-(void) findUsers



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
