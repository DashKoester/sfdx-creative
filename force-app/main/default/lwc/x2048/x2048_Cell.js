export class Cell {

  constructor(value, color) {
    if  (!value || !color) {
      this.value = null;
      this.color =  'cell';
    } else {
      this.value = value;
      this.color = color;
    }
  }
}