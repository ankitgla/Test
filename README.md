# Flicker Photo Search API Example

For Search:- https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key={API_KEY}&format=json&nojsoncallback=1&safe_search=1&text=(SEARCH_TEXT)&page={PAGE_NO}
For Photo:- http://farm{FARM}.static.flickr.com/{SERVER}/{PHOTO_ID}_{SECRET}_q.jpg

Classes Descriptions

SearchVC :- 
Manages search delegate as well as collection delegate and make call as per user action

CollectionCell :- 
This collection cell work in 4 different type which update UI depends on type
	kDefault, //Show Image or Activity indicator
	kNoResult, // No result in list
	kCallInProgress, //This appear at end of collection if we have active network call whose data is coming 
	kENDOFResult, // End of search Result

ImageDownloader :- 
This class is used to download image data and pass to SearchVC

PhotoSearchCall :- 
This class manage all photo search API calls and process the data and pass to SearchVC using completion handler.

NetworkQueueManager :- 
Maintain operation queue which contains all network operation.
This Same class also have cache which maintain separate cache for search call as well as image call.
In case of low memory and app goes in background. It remove all cache and cancel all network operation.

NetworkOperation :- 
Class which was used to create Network operation. This same class handle both image and search operation.

DataModel
	Photo :- Contains value of each photo model
	PhotoData :- contains update pagination value and every photo model related to search string


