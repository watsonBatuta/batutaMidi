void mainDraw(int x, int y, int scale){
//desenho principal
  beginShape();
  pushMatrix();
  smooth();
  noFill();
  stroke(255, 100, 250);
  translate(x, y); // posição

  float newscaler0 = scale;
  for (int s = 8; s > 0; s--) {  
    
  
    //float mm = m + s;
    //float nn1 = n1 + s;
    //float nn2 = mouseY + s;
    //float nn3 = mouseX/100 + s;
    float mm = m + s; //qtd de pontas
    float nn1 = random(0,5); // variableNN1;
    float nn2 = n2 + s; // ponta esquerda
    float nn3 = n3 + s; // ponta direita
    
    newscaler0 = newscaler0 * 0.95;
    float sscaler = newscaler0;
    
    //println ("mm-> " + mm, " nn1 -> "+nn1+" nn2 -> "+ nn2+"nn3 ->"+nn3+" newscaler-> "+newscaler0);

    PVector[] points = superformula(mm, nn1, nn2, nn3);
    
    curveVertex(points[points.length-1].x * sscaler, points[points.length-1].y * sscaler);
    
    for (int i = 0;i < points.length; i++) {
      //stroke(255, 0, 0);
      curveVertex(points[i].x * sscaler, points[i].y * sscaler);
      
    }
    //curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    
  }
  endShape();
  popMatrix();

}

//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
void instrument(int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3){
//desenho 0
  beginShape();
  pushMatrix();
  stroke(R, G, B);
  smooth();
  noFill();
  translate(x , y); // posição

  float newscaler = scale;
  for (int s = 5; s > 0; s--) {  

  
    //float mm = m + s;
    //float nn1 = n1 + s;
    //float nn2 = mouseY + s;
    //float nn3 = mouseX/100 + s;
    float mm = variableMM; //qtd de pontas
    float nn1 = variableNN1; // variableNN1
    float nn2 = variableNN2; // ponta esquerda
    float nn3 = variableNN3; // ponta direita
    
    newscaler = newscaler * 0.95;
    float sscaler = newscaler;
    
    //println ("mm-> " + mm, " nn1 -> "+nn1+" nn2 -> "+ nn2+"nn3 ->"+nn3+" newscaler-> "+newscaler);

    PVector[] points = superformula(mm, nn1, nn2, nn3);
    curveVertex(points[points.length-1].x * sscaler, points[points.length-1].y * sscaler);
    for (int i = 0;i < points.length; i++) {
      curveVertex(points[i].x * sscaler, points[i].y * sscaler);
    }
    //curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    
  }
  endShape();
  popMatrix(); 
}

PVector[] superformula(float m,float n1,float n2,float n3) {
  int numPoints = 360;
  float phi = TWO_PI / numPoints;
  PVector[] points = new PVector[numPoints+1];
  for (int i = 0;i <= numPoints;i++) {
    points[i] = superformulaPoint(m,n1,n2,n3,phi * i);
  }
  return points;
}

PVector superformulaPoint(float m,float n1,float n2,float n3,float phi) {
  float r;
  float t1,t2;
  float a=1,b=1;
  float x = 0;
  float y = 0;

  t1 = cos(m * phi / 4) / a;
  t1 = abs(t1);
  t1 = pow(t1,n2);

  t2 = sin(m * phi / 4) / b;
  t2 = abs(t2);
  t2 = pow(t2,n3);

  r = pow(t1+t2,1/n1);
  if (abs(r) == 0) {
    x = 0;
    y = 0;
  }  
  else {
    r = 1 / r;
    x = r * cos(phi);
    y = r * sin(phi);
  }

  return new PVector(x, y);
}