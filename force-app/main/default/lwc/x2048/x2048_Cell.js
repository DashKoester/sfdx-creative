export class Cell {

  constructor(value, color) {
    if  (!value || !color) {
      this.value = null;
      this.color =  '#cdc1b4';
    } else {
      this.value = value;
      this.color = color;
    }
  }
}