//
//  TableViewController.m
//  EYTagView_Example
//
//  Created by ericyang on 10/11/15.
//  Copyright © 2015 Eric Yang. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "EYTagView.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath* indexPath=[self.tableView indexPathForSelectedRow];
    ViewController* vc=  segue.destinationViewController;

    vc.type=indexPath.row%(EYTagView_Type_Flow+1);
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EYTagView_Type_Flow+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self performSegueWithIdentifier:@"Segue" sender:self];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
  switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=@"EYTagView_Type_Edit";
        }
            break;
        case 1:
        {
            cell.textLabel.text=@"EYTagView_Type_Edit_Only_Delete";
        }
            break;
        case 2:
        {
            cell.textLabel.text=@"EYTagView_Type_Display";
        }
            break;
        case 3:
        {
            cell.textLabel.text=@"EYTagView_Type_Single_Selected";
        }
            break;
        case 4:
        {
            cell.textLabel.text=@"EYTagView_Type_Multi_Selected";
        }
            break;
        case 5:
        {
            cell.textLabel.text=@"EYTagView_Type_Multi_Selected_Edit";
        }
            break;
        case 6:
        {
            cell.textLabel.text=@"EYTagView_Type_Flow";
        }
            break;        
  }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
