//
//  ViewController.m
//  Firebase1
//
//  Created by Nielson Rolim on 12/9/14.
//  Copyright (c) 2014 Mobilife. All rights reserved.
//

#import "ViewController.h"
#import "FirebaseObjects/FirebaseCollection.h"
#import <Firebase/Firebase.h>
#import "User.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblCondition;
@property (weak, nonatomic) IBOutlet UITableView *tbvUsers;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;

@property (strong, nonatomic) Firebase* fbCondition;
@property (strong, nonatomic) Firebase* fbStaff;
@property (strong, nonatomic) NSMutableDictionary* usersDictionary;
@property (strong, nonatomic) FirebaseCollection* usersCollection;

@end

@implementation ViewController

- (NSMutableDictionary*) usersDictionary {
    if (!_usersDictionary) {
        _usersDictionary = [NSMutableDictionary dictionary];
    }
    return _usersDictionary;
}

- (Firebase*) fbCondition {
    if (!_fbCondition) {
        NSString* firebaseURL = @"https://resplendent-inferno-2275.firebaseio.com/condition";
        _fbCondition = [[Firebase alloc] initWithUrl:firebaseURL];
    }
    return _fbCondition;
}

- (Firebase*) fbStaff {
    if (!_fbStaff) {
        NSString* firebaseURL = @"https://resplendent-inferno-2275.firebaseio.com/staff";
        _fbStaff = [[Firebase alloc] initWithUrl:firebaseURL];
    }
    return _fbStaff;
}

- (FirebaseCollection*) usersCollection {
    if (!_usersCollection) {
        _usersCollection = [[FirebaseCollection alloc] initWithNode:self.fbStaff dictionary:self.usersDictionary type:[User class]];
    }
    return _usersCollection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.fbCondition observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.lblCondition.text = snapshot.value;
    }];
    
    self.usersCollection = [[FirebaseCollection alloc] initWithNode:self.fbStaff dictionary:self.usersDictionary type:[User class]];
    
    [self.usersCollection didAddChild:^(User * user) {
        // created remotely or locally, it is called here
//        NSLog(@"New User %@", user.name);
        [self.tbvUsers reloadData];
    }];
    
//    [self.usersCollection didRemoveChild:^(User * user) {
//        // created remotely or locally, it is called here
//        //        NSLog(@"New User %@", user.name);
//        [self.tbvUsers reloadData];
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sunnyButtonPressed:(UIButton *)sender {
    [self.fbCondition setValue:@"Sunny!"];
}

- (IBAction)foggyButtonPressed:(UIButton *)sender {
    [self.fbCondition setValue:@"Foggy!"];
}

- (IBAction)addUserButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    
    User * me = [User new];
    me.name = self.txtUsername.text;
    self.txtUsername.text = @"";
    [self.usersCollection addObject:me];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.usersDictionary.allValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    User* user = [self.usersDictionary.allValues objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *keys = [self.usersDictionary allKeys];
        id theKey = [keys objectAtIndex:indexPath.row];
        User* user = [self.usersDictionary objectForKey:theKey];
        
        [self.usersDictionary removeObjectForKey:theKey];
        [self.usersCollection removeObject:user];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end