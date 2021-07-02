
Mobiquity - Code Challenge
  
The goal of this assignment is to evaluate the problem solving skills, UX judgement and code quality of the candidate. 
 
Weather, everybody wants to know how it is going to be during the week. Will it be rainy, windy, or sunny? Luckily for us, in the information age, there are open APIs to retrieve information about it.
 
For this assignment you will be using the API from: ​http://openweathermap.org/api​. The API key is provided at the end of the statement, or you can request your own by registering on the website for free.
 
Your app should at least contain the following screens:
 
●  	Home screen:
 
○  	Showing a list of locations that the user has bookmarked previously.
 
○  	Show a way to remove locations from the list
 
○  	Add locations by placing a pin on the map.
 
●  	City screen: once the user clicks on a bookmarked city this screen will appear. On this screen the user should be able to see:
 
○  	Today’s forecast, including: temperature, humidity, rain chances and wind information
 
●  	Help screen: The help screen should be done using a webview, and contain information of how to use the app, gestures available if any, etc.
 
The following bonus points can be implemented:
 
●  	Settings page: where the user can select some preferences like: unit system (metric/imperial), any other user setting you consider relevant, e.g. reset cities bookmarked.
 
●  	On the city screen: show the 5-days forecast, including: temperature, humidity, rain chances and wind information.
 
●  	On the home screen, implement a list of known locations with search capabilities.
How navigation occurs, or how elements are placed on the screen is open for interpretation and creativity.
  
Additionally, the following requirements have to be met:
 
●  	Alpha/beta versions of the IDE are forbidden, you must work with the stable version of the IDE
 
●  	The API has to be consumed in JSON format
 
●  	The UI has to be responsive (landscape and portrait orientations, and tablet resolutions must be supported)
●  	The code has to be published on Private GitHub or Private Bitbucket Repo. We want to see the progress evolution (Having Private Repo is mandatory)
 
●  	For Android:
 
○  	Programming language should be Kotlin.
 
○  	The coordinator layout must be used at least in one of the screens.
 
○  	UI has to be implemented using single activity with multiple fragments.
 
 
○  	Should be compatible with Android 5.0+ and should also support the latest Android OS version as well.
○  	Code should be unit testable, Added advantage if code is unit tested using Junit, Mockito, Power Mockito.
○  	Candidates should be able to explain the architecture pattern used and it's explanation of choosing it.
○  	Use of the Android Jetpack component will be an added advantage.
 
●  	For iOS:
 
○  	Programming language should be Swift version 5.0+
 
○  	UICollectionView or UIStackView must be used at least in one of the screens
 
○  	Compatible with iOS 13.0+
 
 
○  	Unit tests must be present, and written using the XCTest framework.
○  	Don’t use any cocoapods, carthage or any third party libraries.
○  	Please use the latest architecture patterns like MVVM, VIPER, VIP, Clean Swift etc. Please Don’t use MVC

 
   
  


API information:
 
API Key: fae7190d7e6433ec3a45285ffcf55c86 
 
Today’s forecast:
Information: ​http://openweathermap.org/current
 
Example of use:
 
http://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=fae7190d7e6433ec3a45285ffcf55c86

 5-days forecast:
Information: ​http://openweathermap.org/forecast5
 
Example of use: 
http://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric


