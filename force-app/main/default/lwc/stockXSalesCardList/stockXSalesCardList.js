import { LightningElement, wire, api, track } from "lwc";

import getSalesData from "@salesforce/apex/StockXSalesCardListController.getSalesData";
import getSalesDataWithPageSize from "@salesforce/apex/StockXSalesCardListController.getSalesDataWithPageSize";
import getObjectDescribes from "@salesforce/apex/StockXSalesCardListController.getObjectDescribes";
import getFieldDescribes from "@salesforce/apex/StockXSalesCardListController.getFieldDescribes";

// imported to dynamically render a template
// import cardGrid from "./cardGrid.html";
// import cardList from "./cardList.html";

export default class StockXSalesCardList extends LightningElement {
  // wire apex functions to properties
  @wire(getSalesData) salesData;
  @wire(getObjectDescribes) objectDescribes;
  @wire(getFieldDescribes) fieldDescribes;

  // dynamic number of records to fetch from the database
  @track pageSize = 10;

  // dynamically calling apex method
  @wire(getSalesDataWithPageSize, { numRecordsToLoad: "$pageSize" })
  salesDataWithPageSize;

  // public
  @api title;
  @api iconName;

  // private
  @track listViewIsSelected = true;
  @track gridViewIsSelected = false;
  @track componentIsLoaded = true;

  // init method (Aura) / componentDidMount (React)
  connectedCallback = () => {
    // this.componentIsLoaded = true;
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
