import { LightningElement, track } from "lwc";

export default class TicTacToe extends LightningElement {
  @track game = {
    round: 1,
    currPlayer: 1
  };

  @track board = {
    cell0: null,
    cell1: null,
    cell2: null,
    cell3: null,
    cell4: null,
    cell5: null,
    cell6: null,
    cell7: null,
    cell8: null
  };

  onCellClick = event => {
    const cellId = event.target.id.split("-")[0];
    // eslint-disable-next-line no-console
    console.log(cellId);

    this.writeToCell(cellId);

    if (this.currPlayer === 2) {
      this.endRound();
    }

    this.changePlayer();
  };

  changePlayer = () => {
    this.currPlayer = this.currPlayer === 1 ? 2 : 1;
  };

  writeToCell = cellId => {
    this.board[cellId] = this.game.currPlayer === 1 ? "X" : "O";
  };

  endRound = () => {
    this.game.round += 1;
  };
}