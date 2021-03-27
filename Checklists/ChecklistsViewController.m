//
//  ChecklistsViewController.m
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ChecklistsViewController.h"
#import "ChecklistItem.h"

@interface ChecklistsViewController ()

@end

@implementation ChecklistsViewController
{
  NSMutableArray *_items;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _items = [[NSMutableArray alloc] initWithCapacity:20];

  ChecklistItem *item;

  item = [[ChecklistItem alloc] init];
  item.text = @"Walk The Dog";
  item.checked = NO;
  [_items addObject:item];

  item = [[ChecklistItem alloc] init];
  item.text = @"Brush My Teeth";
  item.checked = YES;
  [_items addObject:item];

  item = [[ChecklistItem alloc] init];
  item.text = @"Learn iOS Development";
  item.checked = YES;
  [_items addObject:item];

  item = [[ChecklistItem alloc] init];
  item.text = @"Soccer Practice";
  item.checked = NO;
  [_items addObject:item];

  item = [[ChecklistItem alloc] init];
  item.text = @"Eat Ice Cream";
  item.checked = YES;
  [_items addObject:item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_items count];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
  UILabel *label = (UILabel *)[cell viewWithTag:1001];

  if (item.checked) {
    label.text = @"✓";
  } else {
    label.text = @"";
  }
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
  UILabel *label = (UILabel *)[cell viewWithTag:1000];
  label.text = item.text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];

  ChecklistItem *item = _items[indexPath.row];

  [self configureTextForCell:cell withChecklistItem:item];
  [self configureCheckmarkForCell:cell withChecklistItem:item];
	
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

  ChecklistItem *item = _items[indexPath.row];
  [item toggleChecked];

  [self configureCheckmarkForCell:cell withChecklistItem:item];
	
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  [_items removeObjectAtIndex:indexPath.row];

  NSArray *indexPaths = @[indexPath];
  [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item
{
  NSInteger newRowIndex = [_items count];
  [_items addObject:item];

  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
  NSArray *indexPaths = @[indexPath];
  [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item
{
  NSInteger index = [_items indexOfObject:item];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  [self configureTextForCell:cell withChecklistItem:item];

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"AddItem"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
  } else if ([segue.identifier isEqualToString:@"EditItem"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
    controller.delegate = self;

    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    controller.itemToEdit = _items[indexPath.row];
  }
}

@end
