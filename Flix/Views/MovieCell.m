//
//  MovieCell.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/23/21.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cardView.layer.cornerRadius = 5.0;
    self.posterView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
