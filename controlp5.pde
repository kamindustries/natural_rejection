void drawGUI() {
  currCameraMatrix = new PMatrix3D(p3d.camera);
  camera();
  if(show_hud==true){
    cp5.draw(); //DRAW CONTROLS AFTER CAMERA FOR GREAT SUCCESS
  }
  p3d.camera = currCameraMatrix;

  // TITLE
  if (show_hud==true){
    fill(0);
    textFont(font1);
    textAlign(LEFT);
    text("Natural Rejection", marginX, marginY + 10);
    text(display_name, marginX + 300, marginY + 10);
  }
  // textFont(fontHeader2);
  // text("Comparing Seattle's Interests in Fiction and Non-fiction", 
  //       marginX, marginY + 58);

  // // LABELS
  // textFont(fontLabelTitle);
  // text("MOST CHECKED OUT TITLES", marginX, marginY+130);
  // textFont(fontSliders);
  // text("ENTIRE LIBRARY", marginX+25, marginY+154);
  // text("WITHIN DEWEY", marginX+25, marginY+175);
  // text("FLIP LABELS", marginX+25, marginY+259);
  // text("TOGGLE LABELS", marginX+25, marginY+279);
  // text("* One block = one week", marginX, marginY+680);

}

void setupGUI() {

  ///////////////////////////////////////////////////////////////////////
  // Sliders
  ///////////////////////////////////////////////////////////////////////


  cp5 = new ControlP5(this); 
  // cp5.setControlFont(fontSliders);
  // cp5.setColorLabel(textColor);
  // spare_slider1 = -0.9;
  // spare_slider2 = 1.0;
  // spare_slider3 = 3.0;
  // spare_slider4 = 1.0;
  // spare_slider5 = 30.0;
  // spare_slider6 = 3.0;
  // spare_slider7 = -20.0;
  cp5.addSlider("spare1")
  .setPosition(marginX, marginY+20)
  .setRange(-1.f, 1.f)
  .setValue(0.1)
  .setSize(300,9)
  ;
  cp5.addSlider("spare2")
  .setPosition(marginX, marginY+30)
  .setRange(0.1, 10.0)
  .setValue(1.5)
  .setSize(300,9)
  ;
  cp5.addSlider("spare3")
  .setPosition(marginX, marginY+40)
  .setRange(0.1, 10.0)
  .setValue(5.0)
  .setSize(300,9)
  ;
  cp5.addSlider("spare4")
  .setPosition(marginX, marginY+50)
  .setRange(0.01, 2.0)
  .setValue(.18)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare5")
  .setPosition(marginX, marginY+60)
  .setRange(0.01, 10.0)
  .setValue(2.5)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare6")
  .setPosition(marginX, marginY+70)
  .setRange(0.0, 1.0)
  .setValue(1.0)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare7")
  .setPosition(marginX, marginY+80)
  .setRange(0.0, 20.0)
  .setValue(10.0)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare8")
  .setPosition(marginX, marginY+90)
  .setRange(0, 1.0)
  .setValue(0.14)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare9")
  .setPosition(marginX, marginY+100)
  .setRange(-1., 1.0)
  .setValue(0.0)
  .setSize(300,9)
  ; 
  // this is important:
  cp5.setAutoDraw(false);

}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom(cp5.getController("spare1"))) {
    spare_slider1 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare2"))) {
    spare_slider2 = theEvent.getController().getValue();
  }
    if (theEvent.isFrom(cp5.getController("spare3"))) {
    spare_slider3 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare4"))) {
    spare_slider4 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare5"))) {
    spare_slider5 = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("spare6"))) {
    spare_slider6 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare7"))) {
    spare_slider7 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare8"))) {
    spare_slider8 = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("spare9"))) {
    spare_slider9 = theEvent.getController().getValue();
  }
  // if (theEvent.isFrom(checkbox)) {
  //     user_toggle_table1 = (int)checkbox.getArrayValue()[0];
  //     user_toggle_table2 = (int)checkbox.getArrayValue()[1];
  //   }
  // if (theEvent.isFrom(checkbox_labels)) {
  //     user_toggle_labels = (int)checkbox_labels.getArrayValue()[0];
  //   }
  // if (theEvent.isFrom(checkbox_label_flip)) {
  //     user_toggle_label_flip = (int)checkbox_label_flip.getArrayValue()[0];
  //   }
}