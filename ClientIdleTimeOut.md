# Introduction #
I was looking around in the net for an effective client/user IDLE TIMEOUT mechanism. My requirement was very simple - The UI should time-out if the user is idle for more than 5 minutes. In geek terminology, IDLE translates to zero keystrokes and zero mouse movements.

After googling around and then spending some time at Flexcoders, I came across a link from the CFML site - an example for just what I wanted to do :) . So, we went and took that script and added a few bells and whistles to it before converting it into a re-usable component. And here's what we have :-

The ClientIdleTimeOut component can be added to an application using-


&lt;flexed:ClientIdleTimeOut id="TimerId" onTimeOut="FunctionPassedFromCaller" listenKeyStroke="true|false" listenMouseMove="true|false" timeOutInterval="1" confirmInterval="1" /&gt;



Now, when the application starts, the timer starts. If there is no user activity for the timeOutInterval specified, then a timeout warning pops up and stays up for confirmInterval time. Once the confirmInterval has been crossed, the application is timedout. At this point, three actions happen - 1. The application is disabled; 2. The FunctionPassedFromCaller set to the onTimeOut attribute is fired; 3. An event of type appTimedOut is dispatched. We can have a listener for this event and fire our actions at this point apart from the onTimeOut function.

So, thats what the ClientIdleTimeOut does :) . Check it out. Enjoy!

Check out [Flexed](http://flexed.wordpress.com) for further info and downloads.