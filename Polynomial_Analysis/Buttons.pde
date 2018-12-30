//Button class
class Buttons{
  float x;
  float y;
  float w;
  float h;
  String text;
  color outlineColour;
  
  //Constructor
  Buttons(float x_, float y_, float w_, float h_, color outlineColour_, String text_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    text = text_;
    outlineColour = outlineColour_;
  }
   
  //Creates the buttons 
  void create(){
    strokeWeight(3);
    stroke(outlineColour);
    rectMode(CENTER);
    fill(255);
    rect(this.x, this.y, this.w, this.h, 7);
    
    //Text on the buttons
    textAlign(CENTER, CENTER);
    textSize(this.h * 0.6);
    fill(0);
    text(text, this.x, this.y - padding * 0.10);
  }
}