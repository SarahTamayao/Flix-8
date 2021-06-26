//
//  FavoriteCell.h
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/25/21.
//

#import <UIKit/UIKit.h>
#import <Cosmos-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet CosmosView *cosmosView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;

@end

NS_ASSUME_NONNULL_END
