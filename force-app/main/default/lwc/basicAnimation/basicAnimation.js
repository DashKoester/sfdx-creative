/* eslint-disable no-console */
import { LightningElement } from 'lwc';
import YEEZY_LOGO_URL from '@salesforce/resourceUrl/Yeezy_Logo';

export default class BasicAnimation extends LightningElement {
    // cross-browser animation frame function
    requestAnimationFrame =
	window.requestAnimationFrame ||
	window.mozRequestAnimationFrame ||
	window.webkitRequestAnimationFrame ||
    window.msRequestAnimationFrame;
    
    // canvas metadata
    canvasWidth = 1000;
    canvasHeight = 400;
    canvas;
    ctx;
    yeezyLogoImage = new Image();

    // animation data
    x = 0;
    y = 0;
    hotizontalSpeed = 2;
    verticalSpeed = 4;

    renderedCallback() {
        this.canvas = this.template.querySelector('canvas');
        this.ctx = this.canvas.getContext('2d');
        this.yeezyLogoImage.src = YEEZY_LOGO_URL;

        this.animateRectangle();
    }

    captureKeyPress2() {
        console.log('yeah');
    }

    captureKeyPress(e) {
        switch(e.keyCode) {
            case 37:
                // left key pressed
                this.leftKeyHandler();
                break;
            case 38:
                // up key pressed
                this.upKeyHandler();
                break;
            case 39:
                // right key pressed
                this.rightKeyHandler();
                break;
            case 40:
                // down key pressed
                this.downKeyHandler();
                break;  
            default:
                break;
        } 
    } 

    leftKeyHandler() {
        console.log('left');
    }

    upKeyHandler() {
        console.log('up');
    }
    rightKeyHandler() {
        console.log('right');
    }

    downKeyHandler() {
        console.log('down');
    }    

    drawImage() {
        this.ctx.drawImage(this.yeezyLogoImage, this.x, this.y, 100, 100);
    }

    clearCanvas() {
        this.ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
    }

    animateRectangle() {
        this.clearCanvas();
        this.drawImage();
    
        if (this.x < 0 || this.x + 100 >= this.canvasWidth) {
            this.hotizontalSpeed = -this.hotizontalSpeed;
        }
    
        if (this.y < 0 || this.y + 100 >= this.canvasHeight) {
            this.verticalSpeed = -this.verticalSpeed;
        }
    
        this.x += this.hotizontalSpeed;
        this.y += this.verticalSpeed;
    
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        requestAnimationFrame(this.animateRectangle.bind(this));
    }
}