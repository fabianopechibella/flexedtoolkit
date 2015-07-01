#Autorefresher component.

# Auto Refresher v1.0 #
If you have been working on applications which serve highly dynamic data on the screen, you are most likely to have had to rely on the “polling” mechanism to get updated data from the back-end. We had similar requirement in our project and we created a tiny component using Flex’s Timer Class to fire a specific method at set frequencies.

And as usual, we didn’t to go around writing code all across the application to do this. The component we created can take in a function as an attribute. This function could be anything. It could be one that fires an SQL query and updates an ArrayCollection, or it could be one that sends out a Feed request or whatever! :) It’s pretty easy to use the AutoRefresher. All you have to do is add the AutoRefresher to your view -
```
<flexed:AutoRefresher id="exampleAutoRefresh" delay="5000" refreshFunction="FunctionToBeFiredPeriodically" />
```
The view then, refreshes every x milliseconds specified for delay. The default is 15000 milliseconds or 15 seconds. In the init method of your view, before starting the autorefresher, set the owner of the refresher to the parent like this-
```
exampleAutoRefresh.owner = this;
exampleAutoRefresh.start();
```
Setting the owner is to make sure that our refresher stops and starts based on the views visibility. In most cases, Polling mechanism ends up being really costly on the back-end. Especially if you are dealing with multi-tiered architecture and trying to talk to a web server, database server etc over the network. And its very much possible, that multiple views in your application might be required to autorefresh periodically. If you are polling in all the screens whether they are required or not, you are most likely to end up crashing the back-end infrastructure. In order to address this problem and minimize the load on the back-end, we built in a mechanism into the refresher by which it stops if the view is visible and starts automatically when the view is visible. This is why we are setting the owner in the init method. So, if you have autorefresher running on view A and B; and the user is viewing view B, then only view B is refreshing and when the user moves to view A; view B stops refreshing and view A starts.

Special thanks to Easwar for making this idea work! This component might come in handy for many :) . It sure saved a lot of effort for us ;) . Check it out.

Note: The demo is very basic. All it does is gets the time every 3 seconds and updates the label in the view.