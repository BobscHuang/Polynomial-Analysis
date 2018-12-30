//Monomial class
class Monomial {
  float coefficient;
  int exponent;
  String variable;
  String display;
  
  //Constructor
  Monomial(float c, int e, String v) {
    this.coefficient = c;
    this.exponent = e;
    this.variable = v;
    this.display = this.getDisplay(v);
  }
  
  //Adds two monomials together
  Monomial addMonomial(Monomial x) {
    return new Monomial(this.coefficient+x.coefficient, this.exponent, this.variable);
  }
  
  //Mutiplies two monomials together
  Monomial multiplyMonomial(Monomial x) {
    if (this.variable.equals(" ") == false){
      return new Monomial(this.coefficient*x.coefficient, this.exponent+x.exponent, this.variable);
    }
    else{
      return new Monomial(this.coefficient*x.coefficient, this.exponent+x.exponent, x.variable);
    }
  }
  
  //Divides two monomials by each other
  Monomial divideMonomial(Monomial x) {
    return new Monomial(this.coefficient/x.coefficient, this.exponent-x.exponent, this.variable);
  }
  
  //Mutiples monomial by an exponent
  Monomial exponentMonomial(int e) {
    return new Monomial(pow(this.coefficient, e), this.exponent * e, this.variable);
  }
  
  //gets the y-value of a monomial at a given x-value
  float getValue(float x) {
    return this.coefficient*pow(x, this.exponent);
  }
  
  //Gets the display of an monomial (in the form of a string)
  String getDisplay(String v) {
    String coefficientDisplay, variableDisplay, exponentDisplay;
          
    if (this.exponent > 1) {
      if (this.coefficient == 1) {
      coefficientDisplay = "";
      }
      else if (this.coefficient == -1) {
        coefficientDisplay = "-";
      }
      else {
        if (this.coefficient == round(this.coefficient)) {
          coefficientDisplay = str((int)this.coefficient);
        }
        else {
          coefficientDisplay = str(this.coefficient);
        }
      }
      
      variableDisplay = v;
      exponentDisplay = "^" + str(this.exponent);
    }
    else if (this.exponent == 1) {
      if (this.coefficient == 1) {
      coefficientDisplay = "";
      }
      else if (this.coefficient == -1) {
        coefficientDisplay = "-";
      }
      else {
        if (this.coefficient == round(this.coefficient)) {
          coefficientDisplay = str((int)this.coefficient);
        }
        else {
          coefficientDisplay = str(this.coefficient);
        }
      }
      
      variableDisplay = v;
      exponentDisplay = "";
    }
    else {
      if (this.coefficient == round(this.coefficient)) {
          coefficientDisplay = str((int)this.coefficient);
        }
      else {
          coefficientDisplay = str(this.coefficient);
      }
      
      variableDisplay = "";
      exponentDisplay = "";
    } 
    
    if (this.coefficient == 0) {
      coefficientDisplay = "";
      variableDisplay = "";
      exponentDisplay = "";
    }
  
  return coefficientDisplay + variableDisplay + exponentDisplay;
  }
  
  //Prints out the string taken from getDisplay 
  void display() {
    println(this.display);
  }
}