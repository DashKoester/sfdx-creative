import { LightningElement, track } from 'lwc';
import { Cell } from './x2048_Cell';

export default class X2048 extends LightningElement {
  @track grid = [
    [new Cell(), new Cell(), new Cell(), new Cell()],
    [new Cell(), new Cell(), new Cell(), new Cell()],
    [new Cell(), new Cell(), new Cell(), new Cell()],
    [new Cell(), new Cell(), new Cell(), new Cell()]
  ]

  // grid metadata
  WIDTH = 4;
  HEIGHT = 4;
  EMPTY_CELL_COLOR = '#cdc1b4';
  GRID_WAS_UPDATED = false;
  populatedCells = new Set();

  // for arrow keys
  blankInputValue = null;

  connectedCallback() {
    this.initBoard();
  }

  initBoard() {
    this.generateNewCell(2);
    this.generateNewCell(2);
  }

  // TODO: update references for account for null colors
  updateCell(row, col, value, color) {
    color = color ? color : this.EMPTY_CELL_COLOR;
    this.grid[row][col] = new Cell(value, color);

    const xyCoord = row + ',' + col;
    if (value) {
      this.populatedCells.add(xyCoord);
    } else {
      this.populatedCells.delete(xyCoord);
    }

    this.GRID_WAS_UPDATED = true;
  }

  handleLeftAction() {
    const startingCol = 0;

    // iterate over each row
    for (let i = 0; i < this.HEIGHT; i++) {

      // iterate over columns
      for (let j = startingCol + 1; j < this.WIDTH; j++) {
        let currentCol = j;

        let currentCell = this.getCell(i, j);

        if (currentCell.value) {
          let adjacentCell = this.getCell(i, currentCol - 1);

          // move cell all the way to the left
          while (currentCol !== 0 && !adjacentCell.value) {
            this.updateCell(i, currentCol - 1, currentCell.value, currentCell.color);
            this.updateCell(i, currentCol, null, this.EMPTY_CELL_COLOR);

            currentCol -= 1;
            currentCell = this.getCell(i, currentCol);
            adjacentCell = this.getCell(i, currentCol - 1);
          }

          // combine cells if they're the same
          if (currentCol !== 0 && adjacentCell.value === currentCell.value) {
            const newValue = adjacentCell.value + currentCell.value;
            this.updateCell(i, currentCol - 1, newValue, this.calculateColor(newValue));
            this.clearCell(i, currentCol);
          }
        }
      }
    }

    if (this.GRID_WAS_UPDATED) {
      this.generateNewCell(2);
    }
  }

  handleRightAction() {
    const startingCol = 3;

    // iterate over each row
    for (let i = 0; i < this.HEIGHT; i++) {

      // iterate over columns
      for (let j = startingCol - 1; j >= 0; j--) {
        let currentCol = j;

        let currentCell = this.getCell(i, j);

        if (currentCell.value) {
          let adjacentCell = this.getCell(i, currentCol + 1);

          // move cell all the way to the right
          while (currentCol !== 3 && !adjacentCell.value) {
            this.updateCell(i, currentCol + 1, currentCell.value, currentCell.color);
            this.updateCell(i, currentCol, null, this.EMPTY_CELL_COLOR);

            currentCol += 1;
            currentCell = this.getCell(i, currentCol);
            adjacentCell = this.getCell(i, currentCol + 1);
          }

          // combine cells if they're the same
          if (currentCol !== 3 && adjacentCell.value === currentCell.value) {
            const newValue = adjacentCell.value + currentCell.value;
            this.updateCell(i, currentCol + 1, newValue, this.calculateColor(newValue));
            this.clearCell(i, currentCol);
          }
        }
      }
    }

    if (this.GRID_WAS_UPDATED) {
      this.generateNewCell(2);
    }
  }

  handleUpAction() {
    const startingRow = 0;

    // iterate over each column
    for (let j = 0; j < this.WIDTH; j++) {

      // iterate over rows
      for (let i = startingRow + 1; i < this.HEIGHT; i++) {
        let currentRow = i;

        let currentCell = this.getCell(i, j);

        if (currentCell.value) {
          let adjacentCell = this.getCell(currentRow - 1, j);

          // move cell all the way to the left
          while (currentRow !== 0 && !adjacentCell.value) {
            this.updateCell(currentRow - 1, j, currentCell.value, currentCell.color);
            this.updateCell(currentRow, j, null, this.EMPTY_CELL_COLOR);

            currentRow -= 1;
            currentCell = this.getCell(currentRow, j);
            adjacentCell = this.getCell(currentRow - 1, j);
          }

          // combine cells if they're the same
          if (currentRow !== 0 && adjacentCell.value === currentCell.value) {
            const newValue = adjacentCell.value + currentCell.value;
            this.updateCell(currentRow - 1, j, newValue, this.calculateColor(newValue));
            this.clearCell(currentRow, j);
          }
        }
      }
    }

    if (this.GRID_WAS_UPDATED) {
      this.generateNewCell(2);
    }
  }

  handleDownAction() {
    const startingRow = 3;

    // iterate over each column
    for (let j = 0; j < this.WIDTH; j++) {

      // iterate over rows
      for (let i = startingRow - 1; i >= 0; i--) {
        let currentRow = i;

        let currentCell = this.getCell(i, j);

        if (currentCell.value) {
          let adjacentCell = this.getCell(currentRow + 1, j);

          // move cell all the way to the left
          while (currentRow !== 3 && !adjacentCell.value) {
            this.updateCell(currentRow + 1, j, currentCell.value, currentCell.color);
            this.updateCell(currentRow, j, null, this.EMPTY_CELL_COLOR);

            currentRow += 1;
            currentCell = this.getCell(currentRow, j);
            adjacentCell = this.getCell(currentRow + 1, j);
          }

          // combine cells if they're the same
          if (currentRow !== 3 && adjacentCell.value === currentCell.value) {
            const newValue = adjacentCell.value + currentCell.value;
            this.updateCell(currentRow + 1, j, newValue, this.calculateColor(newValue));
            this.clearCell(currentRow, j);
          }
        }
      }
    }

    if (this.GRID_WAS_UPDATED) {
      this.generateNewCell(2);
    }
  }

  clearCell(row, col) {
    this.updateCell(row, col, null, this.EMPTY_CELL_COLOR);
  }

  generateNewCell(value) {
    let newCellRow = Math.floor(Math.random() * 4);
    let newCellCol = Math.floor(Math.random() * 4);

    while (this.populatedCells.has(newCellRow + ',' + newCellCol)) {
      newCellRow = Math.floor(Math.random() * 4);
      newCellCol = Math.floor(Math.random() * 4);
    }

    this.updateCell(newCellRow, newCellCol, value, this.calculateColor(value));
    this.GRID_WAS_UPDATED = false;
  }

  calculateColor(value) {
    switch (value) {
      case 2:
        return 'RED';
      case 4:
        return 'GREEN';
      case 8:
        return 'BLUE';

      default:
        return 'DEFAULT COLOR';
    }
  }

  getCell(row, col) {
    if ((row >= 0 || row < this.WIDTH) && (col >= 0 && col < this.HEIGHT)) {
      return this.grid[row][col];
    }
  }

  captureKeyPress(e) {
    switch (e.keyCode) {
      case 65:
        this.handleLeftAction();
        break;
      case 87:
        this.handleUpAction();
        break;
      case 68:
        this.handleRightAction();
        break;
      case 83:
        this.handleDownAction();
        break;

      default:
        break;
    }
  }

  // getters
  get cell0Value() { return this.grid[0][0].value }
  get cell1Value() { return this.grid[0][1].value }
  get cell2Value() { return this.grid[0][2].value }
  get cell3Value() { return this.grid[0][3].value }
  get cell4Value() { return this.grid[1][0].value }
  get cell5Value() { return this.grid[1][1].value }
  get cell6Value() { return this.grid[1][2].value }
  get cell7Value() { return this.grid[1][3].value }
  get cell8Value() { return this.grid[2][0].value }
  get cell9Value() { return this.grid[2][1].value }
  get cell10Value() { return this.grid[2][2].value }
  get cell11Value() { return this.grid[2][3].value }
  get cell12Value() { return this.grid[3][0].value }
  get cell13Value() { return this.grid[3][1].value }
  get cell14Value() { return this.grid[3][2].value }
  get cell15Value() { return this.grid[3][3].value }
}