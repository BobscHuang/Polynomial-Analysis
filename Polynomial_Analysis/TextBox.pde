//TextBox class (special "textboxes" made for only this program)
class TextBox{
  float x1;
  float y1;
  float x2;
  float y2;
  String content;
  Polynomial function = null;
  boolean ready = false;
  color outlineColour;
  color circleColour;
  String roots;
  
  //Constructor
  TextBox(float x1_, float y1_, float x2_, float y2_, color outlineColour_){
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    content = "";
    outlineColour = outlineColour_;
    circleColour = color(255);
  }
  
  //Creates the textboxes
  void create(){
    strokeWeight(3);
    stroke(outlineColour);
    rectMode(CORNERS);
    fill(255);
    rect(this.x1, this.y1, this.x2, this.y2, 4);
    
    //Small circles beside textbox that indicates function colour
    ellipseMode(RADIUS);
    fill(circleColour);
    ellipse((this.x2 + width) / 2, (this.y1 + this.y2) / 2, (this.y2 - this.y1) / 2, (this.y2 - this.y1) / 2);
    
    //Texts in the textboxes
    textAlign(CENTER, CENTER);
    textSize((this.y2 - this.y1) * 0.7);
    fill(0);
    text(content, (this.x1 + this.x2) / 2, (this.y1 + this.y2) / 2 - padding * 0.12);
    
    //Displays the roots (if possible)
    if (this.ready == true && outlineColour == color(255, 0, 0)){
      text("Roots: " + this.roots, (boxArray.get(0).x1 + boxArray.get(0).x2) / 2, (boxArray.get(2).y2 + boxArray.get(3).y1) / 2);
    }
  } 
}