void drawGUI() {
  currCameraMatrix = new PMatrix3D(p3d.camera);
  camera();
  if(show_hud==true){
    cp5.draw(); //DRAW CONTROLS AFTER CAMERA FOR GREAT SUCCESS
  }
  p3d.camera = currCameraMatrix;

  // TITLE
  if (show_text==true){
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
  color invert_bg = color(255-red(bg_color),255-green(bg_color),255-blue(bg_color));
  cp5.setColorLabel(invert_bg);

  cp5.addSlider("halo displace")
  .setPosition(marginX, marginY+(2*hud_spacing)+hud_offset)
  .setRange(-1.f, 1.f)
  .setValue(0.1)
  .setSize(300,9)
  .setLabelVisible(true)
  ;
  cp5.addSlider("main stroke w")
  .setPosition(marginX, marginY+(3*hud_spacing)+hud_offset)
  .setRange(0.1, 10.0)
  .setValue(.7)
  .setSize(300,9)
  ;
  cp5.addSlider("halo stroke w")
  .setPosition(marginX, marginY+(4*hud_spacing)+hud_offset)
  .setRange(0.1, 10.0)
  .setValue(2.0)
  .setSize(300,9)
  ;
  cp5.addSlider("grow dir mult")
  .setPosition(marginX, marginY+(5*hud_spacing)+hud_offset)
  .setRange(0.01, 2.0)
  .setValue(.18)
  .setSize(300,9)
  ;  
  cp5.addSlider("perturb mult")
  .setPosition(marginX, marginY+(6*hud_spacing)+hud_offset)
  .setRange(0.01, 10.0)
  .setValue(2.5)
  .setSize(300,9)
  ;  
  cp5.addSlider("thickness offset")
  .setPosition(marginX, marginY+(7*hud_spacing)+hud_offset)
  .setRange(0.0, 10.0)
  .setValue(10.0)
  .setSize(300,9)
  ;  
  cp5.addSlider("thickness random")
  .setPosition(marginX, marginY+(8*hud_spacing)+hud_offset)
  .setRange(0.0, 1.0)
  .setValue(.14)
  .setSize(300,9)
  ;  
  cp5.addSlider("color r")
  .setPosition(marginX, marginY+(9*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.9)
  .setSize(300,9)
  ;  
  cp5.addSlider("color g")
  .setPosition(marginX, marginY+(10*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.1)
  .setSize(300,9)
  ; 
  cp5.addSlider("color b")
  .setPosition(marginX, marginY+(11*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.1)
  .setSize(300,9)
  ;
  cp5.addSlider("color rand")
  .setPosition(marginX, marginY+(12*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(.1)
  .setSize(300,9)
  ;
  // this is important:
  cp5.setAutoDraw(false);

}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom(cp5.getController("halo displace"))) {
    spare_slider1 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("main stroke w"))) {
    spare_slider2 = theEvent.getController().getValue();
  }
    if (theEvent.isFrom(cp5.getController("halo stroke w"))) {
    spare_slider3 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("grow dir mult"))) {
    spare_slider4 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("perturb mult"))) {
    spare_slider5 = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("thickness offset"))) {
    spare_slider6 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("thickness random"))) {
    spare_slider7 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("color r"))) {
    spare_slider8 = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("color g"))) {
    spare_slider9 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("color b"))) {
    spare_slider10 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("color rand"))) {
    spare_slider11 = theEvent.getController().getValue();
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