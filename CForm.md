# CForm v1.0 #
CForm is all about creating data entry screens. This component allows developers to create standardized forms/CRUD screens in their applications. The CForm component is a Data Entry component that can be very useful if -

  1. you are building business applications with many data entry/view screens
  1. you are working with a lot of developers. each handling separate screens/modules
  1. you wish all your screens to have the standard look & feel across the application
  1. you wish to avoid different developers/designers designing their own UI/UX paradigms for their specific screens

Let me try to explain this in a very simplified manner. CForm reads XML file to create user entry forms. To implement CForm, the following steps are involved.

  * Developer creates XML file for each screen. The XML will contain the list of fields, controls to be used etc.
  * CForm is called in an MXML.
  * Now, the developer can use many of CForm’s exposed methods to access/manipulate data in the CForm.