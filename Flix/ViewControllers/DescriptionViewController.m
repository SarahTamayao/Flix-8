//
//  DescriptionViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/24/21.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardView.layer.cornerRadius = 10.0;
    self.descriptionLabel.text = self.movie[@"overview"];
}

- (IBAction)onTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
