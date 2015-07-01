# CGrid v1.2 - Custom DataGrid #
Releasing the v1.2 of CGrid. It’s been in drafts for a long while now.This time, a few more basic niceties have been added to the CGrid. :)

## Few Key Features ##

  1. Takes in Column names and data as an arraycol.
  1. Two kinds of data search – Filtering & Highlighting.
  1. Displays a data count.
  1. Printing the grid contents.
  1. Status area.
  1. Export to Excel (Copy selected rows or entire grid to clipboard and paste in excel)
  1. User can select columns to view and width of the columns etc. This setting for each   grid in the application is remembered across sessions.(For this to work properly, you will have to ensure that you always specify a distinct ID for for each grid in your application.) This feature is very useful, if you are fetching a lot of columns to display but are not sure whether all the users would be interested in all the columns. Now, the user can choose to see columns of his/her choice and that choice is remembered across sessions.
  1. Fixed the sorting logic in the column sort.
  1. The CGrid can now take in custom itemRenderer from the caller.

## Usage and Implementation ##
Pass in the columns of the grid as one arraycollection and the data as another arraycollection.

### MXML ###
```
<grid:CGrid id="<Grid ID>" printTitle="<GRID PRINT TITLE>" searchType="<SEARCH TYPE – filter | highlight>"/>
```
### Add Columns ###
```
public var gridColumns:ArrayCollection = new ArrayCollection([{
colname:”COL NAME”,
colwidth:”COL WIDTH”,
coldata:”COL DATA”,
align:”COL ALIGN”,
labelfunction:”COL DATA MANIPULATION FUNCTION”,
sortable:”TRUE | FALSE”
}]);
gridId.drawColumns(Columns ArrayCollection);
```
### Load Data ###
```
gridId.loadData(Data as ArrayCollection);
```
### Add controls to the cgrid (near row info) ###
```
gridId.addControls(UIbject);
```
### Set text to the status bar ###
```
gridId.statusBar.text = “text to be printed in status bar”;
```
### Adding an ItemRenderer ###
When defining the columns array use the following syntax for the column where you want the itemRenderer -
```
{colname:"Name",coldata:"data",
renderer:renderers.ButtonRenderer}
```

Check out the blog post [here](http://flexed.wordpress.com/2007/08/15/customgrid-v12/) at [Flexed](http://flexed.wordpress.com/)