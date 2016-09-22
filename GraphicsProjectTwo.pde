// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.util.NoSuchElementException;
import java.util.Arrays;

//**************************** global variables ****************************
import controlP5.*;
ControlP5 cp5;

pts[] polygons;// class containing array of points, used to standardize GUI
pts[] secretPolygons;
pts cuttablePolygon, selectedPolygon, selectedSecretPolygon; //polygon that can currently be legally cut by the green arrow.
int selectedPolygonIndex;
floatptPair[] goodTs;  //t parameters for points on currently cuttable polygon.
float t=0, f=0;
boolean animate=true, fill=false, timing=false, lerping = false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
pt A=P(200,100), B=P(500,300), closestPoint;
int index = 0;
int size = 0;
int solved = 0;
pts ghost = null;
int gameStage = -1; //-1 = make shape, 0 = designer cutting stage, 1 = designer moving polygons, 2 = player stage... 3 = win?
//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(1200, 800);            // window size
  cp5 = new ControlP5(this);
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  polygons = new pts[20];
  polygons[0] = new pts();
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  polygons[0].declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  polygons[0].loadPts("data/pts");  // loads points form file saved with this program
  size++;
  closestPoint = new pt(0, 0);
  selectedPolygon = polygons[0];
  //controlP5 buttons
  cp5.addBang("TranslateMode")
       .setPosition(1080, 700)
       .setSize(100, 30)
       .setLabel("To Cutting Mode")
       .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
       ;
  cp5.addBang("Play")
       .setPosition(1080, 750)
       .setSize(100, 30)
       .setLabel("Play!")
       .hide()
       .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
       ;
  cp5.addTextlabel("Victory")
     .setText("You Win! Congratulations!")
     .setPosition(550, 50)
     .setColorValue(0x00000000)
     .setFont(createFont("Georgia",20))
     .hide()
     ;
  
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pen(black,3); fill(yellow); // shows polyloop with vertex labels
    
    if (gameStage == -1) {
      pen(black,3);
      for (int i = 0; i < size; i++) {
        fill(yellow);
        polygons[i].drawCurve();
        polygons[i].IDs();
      }
    }
    
    if (gameStage == 0) { //code for the cutting part goes in here.
      pen(black,3);
      for (int i = 0; i < size; i++) {
        fill(yellow);
        polygons[i].drawCurve();
        //polygons[i].IDs();
      }
      cuttablePolygon = null;
      goodTs = null;
      stroke(red);
      for (int i = 0; i < polygons.length - 1; i++) {
        if (polygons[i] == null) break;
        show(polygons[i].Centroid(), 10); //show centroids
        if (cuttablePolygon == null) {
          boolean cut = polygons[i].checkStabs(A,B);
          if (cut) {
            index = i;
          }
        }
      }
      if (cuttablePolygon == null) {
        pen(red,5);
        arrow(A,B);
      } else {
        pen(green,5);
        arrow(A,B);
      }
    }
    
    if (gameStage == 1) {
      fill(118, 118, 118);
      ghost.drawCurve();
      pen(black,3);
      for (int i = 0; i < size; i++) {
        fill(yellow);
        polygons[i].drawCurve();
        //polygons[i].IDs();
      }
      if (!mousePressed) {
        pt o = new pt(0,0);
        selectedPolygon = null;
        for (int i = 0; i < size; i++) {
          if (polygons[i].countStabs(Mouse(), o) % 2 == 1) {
            selectedPolygon = polygons[i];
            break;
          }
        }
      }
    }
    
    if (gameStage == 2) {
      fill(118, 118, 118);
      ghost.drawCurve();
      pen(black,3);
      for (int i = 0; i < size; i++) {
        fill(yellow);
        polygons[i].drawCurve();
        secretPolygons[i].drawCurve();
        //polygons[i].IDs();
      }
      if (!lerping) {
        if (selectedPolygon != null && selectedPolygon.drawn) show(selectedPolygon.Centroid(), 10);
      } else {
        t += .05;
        selectedPolygon.drawLerp(selectedSecretPolygon, t);
        println("T: " + t);
        if (t >= 1) {
          lerping = false;
          selectedSecretPolygon.drawn = true;
          solved++;
          if(solved == size) {
            cp5.getController("Victory").show();
          }
        }
      }
      
      
      
    }

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  
  
public void TranslateMode() {
  if (gameStage == -1) {
    gameStage = 0;
    cp5.get(Bang.class, "TranslateMode").setLabel("To Translate Mode");
    ghost = polygons[0];
  } else if (gameStage == 0) {
    gameStage = 1;
    cp5.get(Bang.class, "TranslateMode").setLabel("To Cutting Mode");
    secretPolygons = new pts[20];
    /*for (int i = 0; i < size; i++) {
      secretPolygons[i] = polygons[i];
    }*/
    //secretPolygons = Arrays.copyOf(polygons, polygons.length);
    //secretPolygons = polygons.clone();
    for (int i = 0; i < size; i++) {
      secretPolygons[i] = new pts(polygons[i]);
      secretPolygons[i].drawn = false;
    }
    println("Making secret Polygons");
    cp5.getController("Play").show();
  } else if (gameStage == 1) {
    gameStage = 0;
    cp5.get(Bang.class, "TranslateMode").setLabel("To Translate Mode");
    cp5.getController("Play").hide();
  }
}

public void Play() {
  gameStage = 2;
  selectedPolygon = null;
  cp5.getController("TranslateMode").hide();
  cp5.getController("Play").hide();
}