import processing.sound.*;


    //Control
boolean mouseHeld;
boolean notHoldingSlider;

slider lastSliderHeld;

int oscNum;

ArrayList<SinOsc>  oscs;
ArrayList<SawOsc>  Sawoscs;
ArrayList<TriOsc>  Trioscs;
ArrayList<SqrOsc>  Sqroscs;
ArrayList<Integer> oscFreqs;

ArrayList<slider> sliders;

void setup()
{
    mouseHeld        = false;
    notHoldingSlider = true;

    oscNum = 5;

    oscs     = new ArrayList<SinOsc>();
    Sawoscs  = new ArrayList<SawOsc>();
    Trioscs  = new ArrayList<TriOsc>();
    Sqroscs  = new ArrayList<SqrOsc>();
    oscFreqs = new ArrayList<Integer>(); 

    sliders = new ArrayList<slider>();

    for (int i = 0; i < oscNum; i++)
    {
        oscFreqs.add(0);
    }

    for (int i = 0; i < oscNum; i++)
    {
        oscs.add(new SinOsc(this));
        Sawoscs.add(new SawOsc(this));
        Trioscs.add(new TriOsc(this));
        Sqroscs.add(new SqrOsc(this));
        oscs.get(i).freq(oscFreqs.get(i));

        sliders.add(new slider(i));
    }

    lastSliderHeld = sliders.get(0);
}

void draw()
{
    notHoldingSlider = true;
    background(0);

    for (slider c_slider : sliders)
    {
        c_slider.draw();
        if (mouseY > ((c_slider.oscInd+0.5)*height/6) && mouseY < ((c_slider.oscInd+1+0.5)*height/6))
        {
            c_slider.adjustVal(new PVector(mouseX,mouseY));
        }
    }


    if (mouseHeld && notHoldingSlider)
    {
        if (mouseX > width/2) { lastSliderHeld.cVal += 1; }
        if (mouseX < width/2) { lastSliderHeld.cVal -= 1; }
        if (lastSliderHeld.cVal > lastSliderHeld.endVal)
        {
            lastSliderHeld.cVal = lastSliderHeld.endVal;
        }
        if (lastSliderHeld.cVal < lastSliderHeld.startVal)
        {
            lastSliderHeld.cVal = lastSliderHeld.startVal;            
        }
    }

    //drawSinBackground();
}


//void drawSinBackground()
//{
//    midBot = new PVector(width/2,height);
//    midTop = new PVector(width/2,0);
//    for (int i = 0; i < 100; i++)
//    {
//        //line();
//    }
//}


class slider{
    int startVal;
    int endVal;
    int cVal;
    int oscInd;
    int oscType;

    slider(int ioscInd)
    {
        oscInd  = ioscInd;
        oscType = 0;

        startVal =    0;
        endVal   = 1000;
        cVal     = startVal;
    }

    void draw()
    {
        oscs.get(oscInd).freq(cVal);
        pushMatrix();
        pushStyle();
        pushStyle();
        stroke(255,0,0);
        strokeWeight(5);
        line(width/10, (oscInd+1)*height/6, 9*width/10, (oscInd+1)*height/6);
        popStyle();
        noStroke();
        ellipse(  width/10, (oscInd+1)*height/6,75,75);
        fill(255,0,0);
        ellipse(  map(cVal,startVal,endVal,width/10,9*width/10),(oscInd+1)*height/6,75,75 );
        stroke(255);
        strokeWeight(2);
        textSize(75);
        textAlign(CENTER,CENTER);
        
        if (oscType==0) {text("Sin",map(cVal,startVal,endVal,width/10,9*width/10),(oscInd+1)*height/6 - 150);}
        if (oscType==1) {text("Saw",map(cVal,startVal,endVal,width/10,9*width/10),(oscInd+1)*height/6 - 150);}
        if (oscType==2) {text("Tri",map(cVal,startVal,endVal,width/10,9*width/10),(oscInd+1)*height/6 - 150);}
        if (oscType==3) {text("Sqr",map(cVal,startVal,endVal,width/10,9*width/10),(oscInd+1)*height/6 - 150);}
        text(str(cVal),map(cVal,startVal,endVal,width/10,9*width/10),(oscInd+1)*height/6 - 75);
        noStroke();
        fill(255);
        ellipse(9*width/10, (oscInd+1)*height/6,75,75);
        popStyle();
        popMatrix();


        //println(oscType);
        if ( oscType == 0 ){    oscs.get(oscInd).freq(cVal);    oscs.get(oscInd).play(); }
        if ( oscType == 1 ){ Sawoscs.get(oscInd).freq(cVal); Sawoscs.get(oscInd).play(); }
        if ( oscType == 2 ){ Trioscs.get(oscInd).freq(cVal); Trioscs.get(oscInd).play(); }
        if ( oscType == 3 ){ Sqroscs.get(oscInd).freq(cVal); Sqroscs.get(oscInd).play(); }
    }

    void adjustVal(PVector mouse)
    {

        //println(mouse.x);
        cVal = floor(startVal + (endVal-startVal) * (mouse.x/(9*width/10)));
        if (cVal > endVal)
        {
            cVal = endVal;
        }
        if (cVal < startVal+endVal*0.02)
        {
            cVal = startVal;            
        }
        //println(cVal);

        lastSliderHeld   = this;
        notHoldingSlider = false;
    }

}



void mousePressed()
{
    mouseHeld = true;
    if (mouseY < height/7)
    {
        if (lastSliderHeld.oscType == 0) {    oscs.get(lastSliderHeld.oscInd).stop(); }
        if (lastSliderHeld.oscType == 1) { Sawoscs.get(lastSliderHeld.oscInd).stop(); }
        if (lastSliderHeld.oscType == 2) { Trioscs.get(lastSliderHeld.oscInd).stop(); }
        if (lastSliderHeld.oscType == 3) { Sqroscs.get(lastSliderHeld.oscInd).stop(); }
        lastSliderHeld.oscType += 1;
        lastSliderHeld.oscType %= 4;
    }
}
void mouseReleased()
{
    mouseHeld = false;
}
