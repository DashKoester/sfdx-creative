import { LightningElement, wire, api } from "lwc";

import getRecords from "@salesforce/apex/CardRecordListController.getRecords";
// import getSalesDataWithPageSize from "@salesforce/apex/CardRecordListController.getSalesDataWithPageSize";
import getObjectDescribes from "@salesforce/apex/CardRecordListController.getObjectDescribes";
import getFieldDescribes from "@salesforce/apex/CardRecordListController.getFieldDescribes";

// imported to dynamically render a template
// import cardGrid from "./cardGrid.html";
// import cardList from "./cardList.html";

export default class CardRecordList extends LightningElement {
  // wire apex functions to properties
  @wire(getRecords) records;
  @wire(getObjectDescribes) objectDescribes;
  @wire(getFieldDescribes) fieldDescribes;

  // dynamic number of records to fetch from the database
  pageSize = 10;

  // public
  @api objectApiName;
  @api title;
  @api iconName;

  // private
  listViewIsSelected = true;
  gridViewIsSelected = false;
  componentIsLoaded = true;

  // init method (Aura) / componentDidMount (React)
  connectedCallback = () => {
    // this.componentIsLoaded = true;
    // eslint-disable-next-line no-console
    console.log('ADDING T HIS SHOULD WORK');
  };

  handleDisplayModeChange = () => {
    this.listViewIsSelected = !this.listViewIsSelected;
    this.gridViewIsSelected = !this.gridViewIsSelected;
  };

  loadMoreRecords = () => {
    this.pageSize += 10;
  };

  // You can import templates and override the render method to dynamically render a template

  // render = () => {
  //   return this.displayMode === LIST ? cardList : cardGrid;
  // };
}