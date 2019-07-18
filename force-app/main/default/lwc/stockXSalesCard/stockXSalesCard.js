import { LightningElement, api } from "lwc";

export default class StockXSalesCard extends LightningElement {
  // public attributes
  @api saleInfo;
  @api objectDescribes;
  @api fieldDescribes;

  // used to show VSCode syntax highlighting
  @api uselessAttribute;

  // init method (Aura) / componentDidMount (React)
  connectedCallback() {
    // eslint-disable-next-line no-console
    console.log(this.fieldDescribes);
  }
}
