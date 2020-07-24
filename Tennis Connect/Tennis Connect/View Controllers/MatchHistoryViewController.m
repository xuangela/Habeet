//
//  MatchHistoryViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchHistoryViewController.h"
#import "MatchHistoryCell.h"
@import Parse;

@interface MatchHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MatchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableSetUp];
}

- (void)tableSetUp {
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

#pragma mark - Table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchHistoryCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"MatchHistoryCell"];
    

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
