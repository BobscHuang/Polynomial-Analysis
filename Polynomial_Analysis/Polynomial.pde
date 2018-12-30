//Polynomial class
class Polynomial {
  String poly;
  ArrayList<Monomial> terms;
  String variable;
  
  //First constructor that takes a polynomial in the form of a string
  Polynomial(String poly_){
    this.poly = spaceAdder(poly_);
    this.variable = getVariable(this.poly);
    this.terms = new ArrayList<Monomial>();
    splitString();
  }
  
  //Second constructor that takes a polynomial in the form of an arrayList with monomials
  Polynomial(ArrayList<Monomial> poly_) {
    this.poly = getStringName(poly_);
    this.variable = getVariable(poly);
    this.terms = new ArrayList<Monomial>();
    for (Monomial m: poly_) {
      this.terms.add(m);
    }
  }
  
  //Adds spaces inbetween operation signs ( + and - )
  String spaceAdder(String x){
    String newString;
    
    if (x.length() > 0){
      newString = x.substring(0, 1);
      
      for (int i = 2; i < x.length(); i++){
        String current = x.substring(i - 1, i);
        
        if (current.equals("+") || current.equals("-")){
          if (x.substring(i - 2, i - 1).equals(" ") == false){
            newString += " ";
            newString += x.substring(i - 1, i);
          }
          else{
            newString += x.substring(i - 1, i);
          }
          if (x.substring(i, i + 1).equals(" ") == false){
            newString += " ";
          }
        }
        else{
          if (i == 2 && current.equals(" ")){
            newString += " ";
          }
          else{
            newString += x.substring(i - 1, i);
          }
        }
      }
      if (x.length() > 1){
        newString += x.substring(x.length() - 1);
      }
    }
    else{
      newString = "Error";
    }
    return newString;
  }
  
  //Splits up the polynomial string into it's components of coefficients and exponents
  void splitString(){
    String x = this.poly;
  
    x = x.replace("+ ", "");
    x = x.replace("- ", "-");
    
    String[] a = split(x, " ");
    
    float c;
    int e;
    
    for (int i = 0; i < a.length; i++){
      
      if ((a[i].indexOf(this.variable) == 1) && (a[i].indexOf("-") == 0)){
        c = -1;
      }
      else if (a[i].indexOf(this.variable) == 0){
        c = 1;
      }
      else if (a[i].indexOf(this.variable) == - 1){
        c = parseFloat(a[i]);
      }
      else{
        c = parseFloat(a[i].substring(0, a[i].indexOf(this.variable)));
      }
      if (a[i].indexOf(this.variable) == a[i].length() - 1){
        e = 1;
      }
      else if (a[i].indexOf("^") == -1){
        e = 0;
      }   
      else{
        e = parseInt(a[i].substring(a[i].indexOf("^")+1));
      }
      if (Float.isNaN(c)){
        this.poly = "Error";
      }
      else{
        terms.add(new Monomial(c, e, this.variable));
      }
    }
  }
  
  //Gets the variable of the polynomial
  String getVariable(String x){
    String variable;
    int index = x.indexOf("^");

    if (x.length() > 0){
      if (x.substring(0, 1).equals(" ")){
        x = "0" + x;
      }
    }
    else{
     return " "; 
    }

    if (index != -1){
      variable = x.substring(index - 1, index);
    }
    
    else{
      index = x.indexOf(" ");
      
      if (index != -1){
        variable = x.substring(index - 1, index);
      }
      else{
        if (Float.isNaN(parseFloat(x.substring(x.length() - 1)))){
          variable = x.substring(x.length() - 1);
        }
        else{
          variable = " ";
        }
      }
    }
    return variable;
  }
  
  //Returns an individual monomial given its index
  Monomial getTerm(int i) {
    return this.terms.get(i);
  }
  
  //Sorts the polynomial from highest degree to lowest degree
  void sortPolynomial(){
    ArrayList<Monomial> newTerms = new ArrayList<Monomial>();
    int termNum = this.terms.size();
    
    for (int j = 0; j < termNum; j++){
      int max = this.terms.get(0).exponent;
      int index = 0;
      
      for (int i = 0; i < this.terms.size(); i++){
        if (this.terms.get(i).exponent > max){
          max = this.terms.get(i).exponent;
          index = i;
        }
      }
      newTerms.add(this.terms.get(index));
      this.terms.remove(index);
    }
    for (int i = 0; i < newTerms.size(); i++){
      this.terms.add(newTerms.get(i));
    }
  }
  
  //Simplfies the polynomial (combining like terms, reducing, etc)
  void simplify() {   
    ArrayList<Monomial> newTerms = new ArrayList<Monomial>();
    Monomial m1, m2;
    
    for (Monomial m: this.terms) {
      newTerms.add(m);
    }
  
    for (int i = 0; i < newTerms.size(); i ++) {
      for(int j = i+1; j < newTerms.size(); j++) {
        m1 = newTerms.get(i);
        m2 = newTerms.get(j);
        
        if (m1.variable.equals(m2.variable) && m1.exponent == m2.exponent) {  
          Monomial addTerm = m1.addMonomial(m2);
          newTerms.set(i, addTerm);
          newTerms.remove(j);
          i = 0;
        }
      }
    }
    
    for (int i = 0; i < newTerms.size(); i ++) {
      for (int j = 0; j < newTerms.size(); j ++) {
        Monomial m = newTerms.get(j);
        if (m.coefficient == 0) {
          newTerms.remove(m);
        }
      } 
    }

    this.terms.clear();
    for (Monomial m: newTerms) {
      this.terms.add(m);
    }
    this.sortPolynomial();
  }
  
  //Adds polynomials together
  Polynomial addPolynomial(Polynomial p) {
    Polynomial sum;
    
    if (variableCheck(p)){
      ArrayList<Monomial> newTerms = new ArrayList<Monomial>();
      for (Monomial m1: this.terms) {
        newTerms.add(m1);
      }
      for (Monomial m2: p.terms) {
        newTerms.add(m2);
      }
      
      sum = new Polynomial(newTerms);
      sum.simplify();
    }
    else{
      sum = new Polynomial("Error");
    }
    
    return sum;
  }
  
  //Subtracts one polynomial from another
  Polynomial subtractPolynomial(Polynomial p) {
    Polynomial difference;
    
    if (variableCheck(p)){
      ArrayList<Monomial> newTerms = new ArrayList<Monomial>();
      for (Monomial m1: this.terms) {
        newTerms.add(m1);
      }
      for (Monomial m2: p.terms) {
        m2.coefficient *= -1;
        m2.display = m2.getDisplay(m2.variable);
        newTerms.add(m2);
      }
      
      difference = new Polynomial(newTerms);
      difference.simplify();
    }
    else{
      difference = new Polynomial("Error");
    }
      
    return difference;
  }
    
  //Mutiplies one polynomial by another
  Polynomial multiplyPolynomial(Polynomial p) {
    Polynomial product;
    
    if (variableCheck(p) == true){
      if (this.terms.size() == 0 || p.terms.size() == 0){
        return new Polynomial("0");
      }
      ArrayList<Monomial> newTerms = new ArrayList<Monomial>();
      for (Monomial m1: this.terms) {
        for (Monomial m2: p.terms) {
          newTerms.add(m1.multiplyMonomial(m2));
        }
      }
      
      product = new Polynomial(newTerms);    
      product.simplify();
    }
    else{
      product = new Polynomial("Error");
    }
    
    return product;
  }
  
  //Divides one polynomial by another
  Polynomial divide(Polynomial p) {
    Polynomial quotient;
    ArrayList<Monomial> quotientPoly = new ArrayList<Monomial>();
    ArrayList<Monomial> remainderPoly = new ArrayList<Monomial>();
    ArrayList<Monomial> dividend = new ArrayList<Monomial>();
    Polynomial remainder, newDividend, newRemainder;
    
    if (getStringName(p.terms).equals("")){
      return new Polynomial ("Error");
    }
    
    else if (this.terms.size() == 0){
      println("Remainder: 0");
      return new Polynomial ("0");
    }
    
    else if (variableCheck(p)){
      for (Monomial m: this.terms) {
        dividend.add(m);
      }
      
      Monomial m1 = terms.get(0);
      Monomial m2 = p.terms.get(0); 
        
      while (m2.exponent <= m1.exponent) {
  
        Monomial quotientMono = m1.divideMonomial(m2);
        quotientPoly.add(quotientMono);
         
        for (int j = 0; j < p.terms.size(); j++) {
          Monomial multiplyMono = quotientMono.multiplyMonomial(p.terms.get(j));
          remainderPoly.add(multiplyMono);
        }
  
        remainder = new Polynomial(remainderPoly);
        remainder.sortPolynomial();
        
        newDividend = new Polynomial(dividend);
        newDividend.sortPolynomial();
  
        newRemainder = newDividend.subtractPolynomial(remainder);
        newRemainder.simplify();
        
        try {
          m1 = newRemainder.terms.get(0);
    
          dividend = newRemainder.terms;
          
          remainderPoly.clear();
        }
        
        catch (IndexOutOfBoundsException e) {
          if (newRemainder.terms.size() == 0) {
            dividend.clear();
            dividend.add(new Monomial(0, 0, " "));
          }
          break;
        }
      }
      
      if (quotientPoly.size() == 0) {
        quotientPoly.add(new Monomial(0, 0, "constant"));
      }
      
      println("Remainder: " + getStringName(dividend));
      
      quotient = new Polynomial(quotientPoly);
      quotient.simplify();
    }
    else{
      quotient = new Polynomial("Error");
    }
    return quotient;
  }
  
  //Gets the derivative of the polynomial
  Polynomial derivative(){
    float c;
    int e;
    ArrayList<Monomial> dydx = new ArrayList<Monomial>();
    
    for (int i = 0; i < this.terms.size(); i++){
      c = this.terms.get(i).coefficient;
      e = this.terms.get(i).exponent;
      c *= e;
      e -= 1;
      dydx.add(new Monomial(c, e, this.variable));
    }
    
    Polynomial prime = new Polynomial(dydx);
    
    prime.simplify();
    
    return prime;
  }
  
  //Gets the roots of a quadratic
  String quadraticRoots() {
    String[] roots;
    String displayRoot = "";
    float a, b, c;
    
    this.simplify();
    sortPolynomial();
    
    if (this.getTerm(0).exponent != 2) {
      roots = new String[1];
      return "Not Quadratic";
    }
    
    else if (this.terms.size() < 3) {
      if ((this.terms.size() == 2) && (this.getTerm(1).exponent == 1)) 
        this.terms.add(new Monomial(0, 0, this.variable));
    
      else if ((this.terms.size() == 2) && (this.getTerm(1).exponent == 0)) 
        this.terms.add(new Monomial(0, 1, this.variable));
      
      else {
        for (int e = 1; e >= 0; e--) 
          this.terms.add(new Monomial(0, e, this.variable));
      }
     
    }
    
    sortPolynomial();
    
    a = this.getTerm(0).coefficient;
    b = this.getTerm(1).coefficient;
    c = this.getTerm(2).coefficient;
    
    if (pow(b, 2) - 4*a*c == 0) {
      roots = new String[1];
      roots[0] = str(-b / (2*a));
    }
    
    else if (pow(b, 2) - 4*a*c > 0) {
      roots = new String[2];
      roots[0] = str(round(((-b - sqrt(pow(b, 2) - 4*a*c))/(2*a)) * 100) / 100.0);
      roots[1] = str(round(((-b + sqrt(pow(b, 2) - 4*a*c))/(2*a)) * 100) / 100.0);
    }
    
    else {
      return "No real roots";
    }
    
    if (roots.length == 1 && float(roots[0]) == 0){
      return "0.0";
    }
     
       
     for (int i = 0; i < roots.length; i++){
      if (i != roots.length - 1){
        displayRoot += roots[i] + ", ";
      }
      else{
        displayRoot += roots[i];
      }
    }
    
     return displayRoot; 
   }
    
  
  //Finds the roots of a linear polynomial
  String linearRoot() {
    this.simplify();
    if (this.terms.size() == 1){
      return "0.0";
    }
    
    float root = (float) (-this.getTerm(1).coefficient / this.getTerm(0).coefficient);
    return str(root);
  }
  
  //Gets the y-value of the polynomial given a x-value
  float getValue(float x) {
    float y = 0;
    for (Monomial m: this.terms) {
      y += m.getValue(x);
    }
    
    return y;
  }
    
  //Combines monomial stored in list into string
  String getStringName(ArrayList<Monomial> monoList){
    String newPoly = "";
    float c;
    
    if (monoList.size() == 0) {
      return "0";
    }
    
    if ((monoList.size() == 1) && (monoList.get(0).coefficient == 0) && (monoList.get(0).exponent == 0)){
      return "0";
    }
    
    for (int i = 0; i < monoList.size(); i++){
      c = monoList.get(i).coefficient;
      String mono = monoList.get(i).display;
      
      if (i != 0){
        if (c > 0){
          newPoly += " + " + mono;
        }
        else if (c < 0){
          newPoly += " - " + mono.substring(mono.indexOf("-") + 1);
        }
      }
      else{
        newPoly += mono;
      }
    }
    return newPoly;
  } //<>//
  
  //Checks if the variables of the two polynomials match
  boolean variableCheck(Polynomial f){
    if(this.variable.equals(" ") == false && f.variable.equals(" ") == false){
      if (this.variable.equals(f.variable)){
        return true;
      }
      else{
        return false;
      }
    }
    return true;
  }
  
  //Prints polynomial as a string
  void display(){
    println(getStringName(this.terms));
  }
  
  //Returns polynomial as a string
  String getDisplay() {
    return getStringName(this.terms);
  }
}