# JustEatTakeaway

1. How long did you spend on the coding test? What would you add to your solution if you had more time? If you didn't spend much time on the coding test then use this as an opportunity to explain what you would add.
  * It took me about 6 hours in this test.
  * Postcode auto detection - Initiall I got a bit stuck on architecting the Network Layer for the app which consumed quite a bit of time.
  * Proper ViewModel structure for RestaurantList Tableview Cell
  * UI Tests
2. What was the most useful feature that was added to the latest version of your chosen language? Please include a snippet of code that shows how you've used it.
  *  `DiffableDatasource` has been recently added to Swift. I used it to create UITableview for Restaurants
  *  Screenshot <img width="1048" alt="DiffableDatasource" src="https://user-images.githubusercontent.com/5270282/170889637-00cbea08-6ec6-4f16-8d70-4bdc37061491.png">

3. How would you track down a performance issue in production? Have you ever had to do this?
  * We have to face several types of issues. Generally we try to catch performance issues in staging environment. Here is how I would try to track down the issue.
  * Verify if its an issue on Frontend, Backend or Network
  * If its a Frontend issue, check where is the most processing being done.
    - See if processing can be sent to background thread.
    - See if we can optimize our timeconsuming algorithm.
    - See if we can make things asynchronous and possibly reduce dependencies.
  * If its  a Backend issue
    - See if we can use pagination in Api calls.
    - See if we can remove extra/unused data in Api calls.
    - See if we can optimize DB query.
    - See if we need to create indexing on DB column.
    - See if we can use cache.
    - See if the load balancing is properly done.
    
4. How would you improve the Just Eat APIs that you just used?
  * There seemed to be a lot of extra data not needed on Frontend. For example several keys seemed to be redundant and some keys just contained uppercasing of some other data.
  * There did not seem to be any Pagination present in api.
