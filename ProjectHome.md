![http://farm1.static.flickr.com/234/455264281_2633c99c3c_o.jpg](http://farm1.static.flickr.com/234/455264281_2633c99c3c_o.jpg)

Flexed toolkit is a set of simple components that can be easily re-used :) When I started working on Flex in 2006, I was really impressed by the framework. I have been using Flex in the project that I am working on presently. And one our goals was to build as many re-usable components so that the developers in the team do not end up re-inventing the wheel everyday. Also, its easy to deal with custom components from a maintenance perspective.

In this process, we learnt a lot from the community, discussion boards, mailing groups and other bloggers. flexedtoolkit is more of an effort to give it back to the community, share the knowledge we have gained and more importantly help other developers around the world save time by using the flextoolkit widgets/utilities.

# Latest News #
First version of CForms released on 2nd January 2008!!! Check it out at
[Flexed](http://flexed.wordpress.com/2008/01/02/component-cform-v10). The post has links to the demo and documentation.


## Using CForm ##
CForm reads XML file to create user entry forms. To implement CForm, the following steps are involved.

**Developer creates XML file for each screen. The XML will contain the list of fields, controls to be used etc.** CForm is called in an MXML.
**Now, the developer can use many of CForm’s exposed methods to access/manipulate data in the CForm.**

### MXML code ###
```
<flexed:CForm id=”cfrm”widgetsFile=”controls.xml” cFormValidation=”validateForm”verticalCenter=”0″ 
verticalScrollPolicy=”auto” horizontalCenter=”0″ 
horizontalScrollPolicy=”off”
width=”100%” height=”100%”/>
```

### AS Code ###

To set xml path and load CForm
```
str = “examples/cform/xmls/controls.xml”;
cfrm.widgetsFile = str;cfrm.init();
```

To get data from CForm
```
obj = cfrm.getData(); // to get only modified values
obj = cfrm.getData(false); // to get all values
```

To reset CForm
```
cfrm.resetCForm();
```

To set data to CForm
```
var oDataToSet:Object = new Object();
oDataToSet.fname = “udayms”;
oDataToSet.age = 27;
oDataToSet.gender = “male”;
cfrm.setData(oDataToSet);
```

To access one field in the CForm and access properties of the widget
```
cfrm.getWidget(“fname”).getUIComponent().addEventListener();
```

To create CForm on the fly using dynamic XML
```
cfrm.createCFormFromXML(new XML());
```

To Validate CForm using custom validation
```
// custom validation function
private function validateForm(id:String,
value:Object, values:Object):ValidationResult{
var result:ValidationResult = new ValidationResult(false);
if(id == “txtCoName”){
if(value == “” || value == null) result = new ValidationResult(true,null,“”,
“You HAVE to enter a company name!”);
}
return result; }
// do this to actually validate the
// CForm. Internally it
// will use validateForm() method.
cfrm.validateCForm();
```