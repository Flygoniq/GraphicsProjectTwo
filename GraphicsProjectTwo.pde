// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.util.NoSuchElementException;

//**************************** global variables ****************************
import controlP5.*;
ControlP5 cp5;

int polyCount = 1;
pts[] polygons;// class containing array of points, used to standardize GUI
pts cuttablePolygon; //polygon that can currently be legally cut by the green arrow.
floatptPair[] goodTs;  //t parameters for points on currently cuttable polygon.
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
pt A=P(200,100), B=P(500,300);
int gameStage = 0; //0 = designer cutting stage, 1 = designer moving polygons, 2 = player stage... 3 = win?
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
  
  //controlP5 buttons
  
  
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pen(black,3); fill(yellow); // shows polyloop with vertex labels
    for (pts polygon : polygons) {
      if (polygon == null) break;
      polygon.drawCurve();
      polygon.IDs();
    }
    
    if (gameStage == 0) { //code for the cutting part goes in here.
      cuttablePolygon = null;
      goodTs = null;
      stroke(red);
      for (pts polygon : polygons) {
        if (polygon == null) break;
        show(polygon.Centroid(), 10); //show centroids
        if (cuttablePolygon == null) {
          polygon.checkStabs(A,B);
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
    

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  