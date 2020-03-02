import { LightningElement, api } from "lwc";

export default class StockXSalesCard extends LightningElement {
  // public attributes
  @api recordInfo;
  @api objectDescribes;
  @api fieldDescribes;
  
  // init method (Aura) / componentDidMount (React)
  connectedCallback() {
    // eslint-disable-next-line no-console
    console.log(this.fieldDescribes);
  }
}