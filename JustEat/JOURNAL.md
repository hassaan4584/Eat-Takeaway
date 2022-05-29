# JOURNAL

This journal explains different aspects of the development of JustEat app

## Planning

After reading the app requirements several times, it was clear that a major chunk of the app is going to related to REST apis, alothough only one api is currently being used. 
    Once the requirements were clear, I tested out the apis given in the requirement document only to find out I was getting _Access Denied_ error. My first huntch was to test it with a VPN, and it worked. Now I can also look at how the response of _SearchByPostcode_ api. 

## Starting to work

I created a simple swift project in Xcode and started working on creating a Network Layer. This is where i kind of prioritized things incorrectly in a way that I started to create a complete generic Netwok Layer whereas looking back at it, i think I should have started with directly making an api call and then enchancing that code. Even though the Network Layer is very decent now, I should have built Bottom-Up rather than Top-Down in terms of Network Layer.
    Another important aspect was to make API calls testable, so the _NetworkManager_ had to conform to some protocol that _MockNetworkManager_ would also conform to and we can inject respective NetworkManager to our _ViewModel_ object

## Working on UI

I had recently seen a video on _Diffable Datasource_ and it had stuck to my mind and decided that this is the time I implement Tableview using the new Reactive approach. In the first I struggled a bit but I was able to quickly get my head around the concept.
Since UI was fully dependent on API data, I hardcoded _MockNetworkManager_ in my ViewController so that i can see all the results on _viewDidLoad_ using sample json I saved earlier. This helped me save quite a bit of time.
Code for _RestaurantTableviewCell_ does not properly follow MVVM pattern. I actually refactored half of it to conform to MVVM pattern but it did not properly justify as it made the code more complex rather than simple, so I did not create a separate ViewModel for the cell.

## Testing

There is one UI component containing its respective Models, View and a ViewModel class. So, the testcases majorly focus on UnitTesting of ViewController and ViewModel. Since our ViewController and ViewModel use initializer based dependency injection, we can pass MockData to validate different behaviours.
Apart from UnitTesting, there is one IntegrationTest added as well that is to make sure APIs are correctly working and if the app is run, the data should correctly be searched and displayed.
  
