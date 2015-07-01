#Custom Alerts v1.0 ~ A Customized Alert that thrown alerts with icons and style! :)

# Custom Alerts v1.0 - Stylized Alerts #
This time we are looking at Alert Messages in Flex. While the flex alerts are nice looking, they are a bit too simple. So, I started looking at options for styling the alerts and found that it quiet easy to get a really sexy look and feel for the Alerts.


# The alert class #
Next, we needed a standard set of alerts that the team can use when they want a popup message anywhere in the application. So, I set about extending the Alert class to create alert.as. With alert class, the developer can popup different messages like this -

### Information ###
```
alert.info('This is an info message');
//you can also pass a clickHandler here.
```
### Confirmation ###
```
alert.confirmation('Are you sure you wish to delete all files?', clickHandler);
```
### Error ###
```
alert.error('This is an error message');
//you can also pass a clickHandler here.
```

So, its as simple as that :) . Check out the blog post at [flexed.wordpress.com](http://flexed.wordpress.com/2007/04/10/styling-alerts-calerts-v10/)
