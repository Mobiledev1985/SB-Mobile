class FisheryDetailsContract {
  final String fisheryPublicID = 'public_id' ;
  final String fisheryVenueName = 'venue_name' ;
  final String address = 'address' ;
  final String addressLine1 = 'line1' ;
  final String addressLine2 = 'line2' ;
  final String addressCity = 'city' ;
  final String addressCounty = 'county' ;
  final String addressPostCode = 'postcode' ;
  final String addressLocation = 'location' ;
  final String addressLocationLat = 'latitude' ;
  final String addressLocationLon = 'longitude' ;
  final String images = 'images' ;
  final String imagesPrimary = 'primary' ;
  final String imagesSecondary = 'secondary' ;
  final String isPremium = 'is_premium' ;
  final String overview = 'overview' ;
  final String quickFacts = 'quick_facts' ;
  final String facilities = 'facilities' ;
  final String lakes = 'lakes' ;
  final String lakesPublicID = 'public_id' ;
  final String lakesInternalId = 'internal_id' ;
  final String lakesPrice = 'price' ;
  final String lakesPriceCurrency = 'price_currency' ;
  final String lakesMaxSize = 'max_size' ;
  final String lakesMaxSizeUnit = 'max_size_unit' ;
  final String lakesType = 'type' ;
  final String lakesName = 'name' ;
  final String lakesTotalSwims = 'total_swims' ;
  final String lakesTotalAnglers = 'num_anglers' ;
  final String lakesNumRods = 'num_rods' ;
  final String lakesAccessType = 'access_type' ;
  final String priceStartsFrom = 'price_start_from' ;
  final String rating = 'rating' ;
  final String ratingScore = 'score' ;
  final String ratingTotalReview = 'total_reviews' ;
  final String contact = 'contact' ;
  final String contactEmail = 'email' ;
  final String contactPrimary = 'primary_contact' ;
  final String contactSecondary = 'secondary_contact' ;
  final String isFavorite = 'is_favorite' ;
  final String isBookable = 'is_bookable' ;

}

class BookingFisheryDetailsContract {
  final String fisheryPublicID = 'fishery_public_id' ;
  final String totalSwims = 'total_swims' ;
  final String totalAnglers = 'total_anglers' ;
  final String totalRods = 'total_rods' ;
  final String lakes = 'lakes' ;
  final String lakesPublicID = 'public_id' ;
  final String lakesInternalID = 'internal_id' ;
  final String lakesName = 'name' ;
  final String images = 'images' ;
  final String lakesPriceCurrency = 'price_currency' ;
  final String lakesMaxSize = 'max_size' ;
  final String lakesMaxSizeUnit = 'max_size_unit' ;
  final String lakesType = 'type' ;
}


class UserBookingsContract {
  final String fishery = 'fishery' ;
  final String booking = 'booking' ;
  
  final String fisheryId = 'id' ;
  final String fisheryImage = 'image' ;
  final String fisheryName = 'name' ;
  final String fisheryCity = 'city' ;
  final String fisheryCounty = 'county' ;
  final String fisheryPostCode = 'postcode' ;
  final String fisheryRating = 'rating' ;
  
  
  final String bookingId = 'id' ;
  final String numAnglers = 'number_of_anglers' ;
  final String numRods = 'number_of_rods' ;
  final String lakeName = 'lake_name' ;
  final String bookedSwims = 'swims' ;
  final String arrivalDate = 'arrival_date' ;
  final String amountPaid = 'amount_paid' ;

}

