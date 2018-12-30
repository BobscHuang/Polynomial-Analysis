//Instructions

//Backspace to delete character
//Delete key to delete entire function
//Enter key to confirm input is complete
//Selection is hightlighted in red
//Mouse wheel to zoom in or zoom out
//Tab key to change the color of the function
//Graph has scale of 1 (each box grid is 1 unit)

//Initiate the basic variables
ArrayList<Polynomial> graphFunctions = new ArrayList<Polynomial>();
color[] colourFunctions = new color[0];

float n = 1;
float m = 1;

float xGraph = 0;
float yGraph = 0;

int scaleX = 1;
int scaleY = 1;

int padding;;
int boxNum = 9;
int boxClicked;
ArrayList<TextBox> boxArray = new ArrayList<TextBox>();

int buttonClicked;
ArrayList<Buttons> buttonArray = new ArrayList<Buttons>();
String[] buttonText = {"+", "-", "/", "x", "y'"};

//Feel free to change the character limit if you have a long input
//However, might not look as nice 
int characterLimit = 25;

//Main setup procedure
void setup() {
  //Recommend scaling of 3 : 2 to work properly
  //Or any wider scaling should also work
  //Recommend 1800 by 1200
  //Others resolutions might not work aswell
  size(1800, 1200);
  padding = height / 30;
  frameRate(60);
  
  //Creates textboxes for inputing function
  for (float i = 0.5; i < 4; i+= 1.3){
    boxArray.add(new TextBox(height + padding, padding * (1 + 2 * i), width - padding * 2, 2 * padding * (1 + i), color(0)));
  }
    
  for (int i = 5; i <= 4 + boxNum; i++){
    boxArray.add(new TextBox(height + padding, padding * (1 + 2 * i), width - padding * 2, 2 * padding * (1 + i), color(0)));
  }
  
  //Creates operation buttons
  float buttonY = (boxArray.get(0).y2 + boxArray.get(1).y1) / 2;
  float buttonCentre = (boxArray.get(0).x1 + boxArray.get(0).x2) / 2;
  for (int i = -2; i < 3; i++){
    buttonArray.add(new Buttons(buttonCentre + padding * i * 2, buttonY, padding, padding, color(0), buttonText[i + 2]));
  }
}

//Return a random colour
color randomColor(){
  int R = int(random(0, 255));
  int G = int(random(0, 255));
  int B = int(random(0, 255));
  return color(R, G, B);
}

//Main draw function
void draw() {
  background(255);
  graph(xGraph, yGraph, n, m, boxArray);
  setting();
} 

//For zooming in and zooming out
void mouseWheel(MouseEvent event) {
  if (event.getCount() < 0) {
    n *= 0.875;
    m *= 0.875;
  }
  else if (event.getCount() > 0) {
    n *= 1.125;
    m *= 1.125;
  }
}

//mouse click event
void mouseClicked(){
  boxClicked = getBoxClicked();
  buttonClicked = getButtonClicked();
}

//Checks key inputs
void keyTyped(){
  
  //For textboxes
  if (boxClicked != 0){
    int characters = boxArray.get(boxClicked - 1).content.length();
    
    //Backspace for deleting single character
    if (key == BACKSPACE){
      if (characters > 0){
        boxArray.get(boxClicked - 1).content = boxArray.get(boxClicked - 1).content.substring(0, characters - 1);;
      }
    }
    
    //Enter key press for confirming function input (updates the textboxes)
    else if (key == ENTER){
      Polynomial temp = new Polynomial(boxArray.get(boxClicked - 1).content);
      if (temp.poly.equals("Error")){
        boxArray.get(boxClicked - 1).content = "Error";
      }
      else{
        temp.simplify();
        boxArray.get(boxClicked - 1).content = temp.getDisplay();
        boxArray.get(boxClicked - 1).function = temp;
        getRoots(boxClicked - 1);
        if (boxArray.get(boxClicked - 1).ready == false){
          boxArray.get(boxClicked - 1).circleColour = randomColor();
        }
        boxArray.get(boxClicked - 1).ready = true;
      }
    }
    
    //Delete key press to completely remove selected function
    else if (key == DELETE){
      boxArray.get(boxClicked - 1).content = "";
      boxArray.get(boxClicked - 1).function = null;
      boxArray.get(boxClicked - 1).ready = false;
      boxArray.get(boxClicked - 1).circleColour = color(255);
    }
    
    //Tab key press to change the colour of selected function (random colour)
    else if (key == TAB){
      if (boxArray.get(boxClicked - 1).ready == true){
          boxArray.get(boxClicked - 1).circleColour = randomColor();
      }
    }
    
    //Makes sure the user dosen't excced the character limit
    else if (characters <= characterLimit){
      boxArray.get(boxClicked - 1).content += key;
    }
  }
  
  //For buttons (checks which buttons is clicked)
  if (buttonClicked != 0){
    if (boxClicked == 1 || boxClicked == 2){
      if (boxArray.get(0).ready == true && boxArray.get(1).ready == true){
        if (boxArray.get(1).content.equals(boxArray.get(1).function.getDisplay()) && boxArray.get(0).content.equals(boxArray.get(0).function.getDisplay())){
          if (buttonArray.get(buttonClicked - 1).text.equals("/")){
            arithmetics("/");
          }
          else if (buttonArray.get(buttonClicked - 1).text.equals("x")){
            arithmetics("x");
          }
          else if (buttonArray.get(buttonClicked - 1).text.equals("+")){
            arithmetics("+");
          }
          else if (buttonArray.get(buttonClicked - 1).text.equals("-")){
            arithmetics("-");
          }
        }
      }
      if (boxArray.get(0).ready == true){
        if (boxArray.get(0).content.equals(boxArray.get(0).function.getDisplay())){
          if (buttonArray.get(buttonClicked - 1).text.equals("y'")){
            arithmetics("y'");
          }
        }
      }
    }
  }
}

//The actual functions of each button
void arithmetics(String operation){
  Polynomial temp = (new Polynomial(boxArray.get(0).content));
  if (temp.poly.equals("Error")){
    boxArray.get(2).content = "Error";
  }
  else{
    Polynomial temp2;
    temp.simplify();
    
    //Checks which operation is selected and executes it
    if (operation.equals("y'")){
      temp2 = temp.derivative();
    }
    else if (operation.equals("/")){
      temp2 = temp.divide(new Polynomial(boxArray.get(1).content));
    }
    else if (operation.equals("x")){
      temp2 = temp.multiplyPolynomial(new Polynomial(boxArray.get(1).content));
    }
    else if (operation.equals("+")){
      temp2 = temp.addPolynomial(new Polynomial(boxArray.get(1).content));
    }
    else if (operation.equals("-")){
      temp2 = temp.subtractPolynomial(new Polynomial(boxArray.get(1).content));
    }
    else{
      temp2 = new Polynomial("Error");
    }
    if (temp2.poly.equals("Error")){
      boxArray.get(2).content = "Error";
    }
    
    //Updates the answer textbox with the solution
    else{
      temp2.simplify();
      boxArray.get(2).content = temp2.getDisplay();
      boxArray.get(2).function = temp2;
      getRoots(2);
      if (boxArray.get(2).ready == false){
        boxArray.get(2).circleColour = randomColor();
      }
      boxArray.get(2).ready = true;
    }
  }
}

//Gets the root(s) of the function and updates it in the display box
void getRoots(int box){
  Polynomial f = boxArray.get(box).function;
  
  if (f.terms.size() == 0){
    boxArray.get(box).roots = "x\u2208\u211d";
  }
  
  else if (f.terms.get(0).exponent == 0){
    boxArray.get(box).roots = "No roots";
  }
  
  else if (f.terms.get(0).exponent == 2){
      boxArray.get(box).roots = f.quadraticRoots();
  }
  else if(f.terms.get(0).exponent == 1){
    boxArray.get(box).roots = f.linearRoot();
  }
  else{
    boxArray.get(box).roots = "Cannot Compute";
  }
}

//The settings panel where the user interacts with
void setting(){
  fill(211, 211, 211);
  stroke(0);
  strokeWeight(3);
  rectMode(CORNERS);
  rect(width, height, height, 0);
  
  //Creates box with "=" symbol
  fill(255);
  rectMode(CENTER);
  rect((boxArray.get(0).x1 + boxArray.get(0).x2) / 2, (boxArray.get(1).y2 + boxArray.get(2).y1) / 2, padding * 3, padding, 7);
  
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(padding);
  text("=", (boxArray.get(0).x1 + boxArray.get(0).x2) / 2, (boxArray.get(1).y2 + boxArray.get(2).y1) / 2 - padding * 0.15);
  
  //Creates box for displaying roots
  fill(255);
  rect((boxArray.get(0).x1 + boxArray.get(0).x2) / 2, (boxArray.get(2).y2 + boxArray.get(3).y1) / 2, padding * 11, padding * 1.5, 7);
  
  //Creates buttons and textboxes
  fill(255);
  for (int i = 0; i < boxArray.size(); i++){
    boxArray.get(i).create();
  }
  for (int i = 0; i < buttonArray.size(); i++){
    buttonArray.get(i).create();
  }
}

//Gets which textbox the user has clicked on
int getBoxClicked(){
  int clicked = 0;
  for (int i = 0; i < boxArray.size(); i++){
    if (mouseX >= boxArray.get(i).x1 && mouseX <= boxArray.get(i).x2 && mouseY >= boxArray.get(i).y1 && mouseY <= boxArray.get(i).y2){
      boxArray.get(i).outlineColour = color(255, 0, 0);
      clicked = i + 1;
    }
    else{
      boxArray.get(i).outlineColour = color(0);
    }
  }
  return clicked;
}

//Gets which button the user has clicked on
int getButtonClicked(){
  int clicked;
  if (buttonClicked == 0){
    clicked = 0;
  }
  else{
    clicked = buttonClicked;
  }
  for (int i = 0; i < buttonArray.size(); i++){
    if (mouseX >= buttonArray.get(i).x - buttonArray.get(i).w / 2 && mouseX <= buttonArray.get(i).x + buttonArray.get(i).w / 2){
      if (mouseY >= buttonArray.get(i).y - buttonArray.get(i).h / 2 && mouseY <= buttonArray.get(i).y + buttonArray.get(i).h / 2){
        buttonArray.get(i).outlineColour = color(0, 0, 255);
        clicked = i + 1;
        for (int j = 0; j < buttonArray.size(); j++){
          if (i != j){
            buttonArray.get(j).outlineColour = color(0);
          }
        }
        return clicked;
      }
    }
  }
  return clicked;
}

//Creates the actual function and the grids (for graphing)
void graph(float xC, float yC, float w, float h, ArrayList<TextBox> f) {
  float xMin = xC - w/2;
  float xMax = xC + w/2;
  float yMin = yC - h/2;
  float yMax = yC + h/2;
  float dx = w / height;
  
  int screenX1, screenY1, screenX2, screenY2;
  
  //For x-axis and y-axis
  stroke(127, 0, 0);
  strokeWeight(3);
  line(0, height/2, height, height/2);
  line(height/2, 0, height/2, height);
  
  //For grid lines
  if (w < 35 && h < 35){
    for (int x = round(-w)-1; x < round(w)+1; x++) {
      stroke(32, 16, 16);
      strokeWeight(1);
      line(getScreenX(x, xMin, xMax), 0, getScreenX(x, xMin, xMax), height);
    }
    
    for (int y = round(-h)-1; y < round(h)+1; y++) {
      stroke(32, 16, 16);
      strokeWeight(1);
      line(0, getScreenY(y, yMin, yMax), height, getScreenY(y, yMin, yMax));
    }
  }
  //For all the functions that are confirmed with the enter key
  for (int i = 0; i < f.size(); i++) {
    stroke(f.get(i).circleColour);
    
    if (f.get(i).ready == true){
      for (float x = xMin; x <= xMax; x += dx) {
        
        screenX1 = getScreenX(x, xMin, xMax);
        screenY1 = getScreenY(f.get(i).function.getValue(x), yMin, yMax);
        screenX2 = getScreenX(x+dx, xMin, xMax);
        screenY2 = getScreenY(f.get(i).function.getValue(x+dx), yMin, yMax);
  
        strokeWeight(3);
        line(screenX1, screenY1, screenX2, screenY2);
      }
    }
  }
}

//Gets the screen x-cord
int getScreenX(float x, float xMin, float xMax) {
  int screenX = (int) ((height/(xMax - xMin))*(x-xMin));
  
  return screenX;
}

//Gets the screen y-cord
int getScreenY(float y, float yMin, float yMax) {
  int screenY = (int) ((height/(yMax-yMin))*(yMax-y));
  
  return screenY;
}