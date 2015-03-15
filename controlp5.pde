void drawGUI() {
  currCameraMatrix = new PMatrix3D(p3d.camera);
  camera();
  if(show_hud==true){
    cp5.draw(); //DRAW CONTROLS AFTER CAMERA FOR GREAT SUCCESS
  }
  p3d.camera = currCameraMatrix;
  

  // TITLE
  textFont(font1);
  if (show_text==true){
    if (selected_branch.name != "trunk"&&selected_branch.name != null) {
      
      if (display_name != selected_branch.name){

          fade_text.clear();
          fade_text_rand.clear();
          text_names_list.clear();
          display_name = selected_branch.name;
          Branch b = selected_branch;

          if (b.parent != null){
            // starting with 6 names...
            for (int i = 0; i < 6; i++) {
              text_names_list.add(new String());
              text_names_list.set(i, b.name);
              int name_length = b.name.length();
              fade_text.add(new float[name_length]);
              fade_text_rand.add(new float[name_length]);
              // print(text_names_array[i]+","+name_length+"; ");
              
              b = b.parent;

              if (b.name == "trunk"||b.name=="null"||b.name==null) {
                // println("");
                // println("null parent at: "+i);
                // println("text names list size: "+text_names_list.size());
                text_names_list.remove(i);
                break;
              }

            }
            // println("text names list size: "+text_names_list.size());
            // println();
            for (int i = 0; i < text_names_list.size(); i++) {
              // println("1) "+i);
              int name_length = text_names_list.get(i).length();
              float[] start_col = new float[name_length];
              // println("2) "+i);
              float[] rand_col = new float[name_length];
              // println("3) "+i);

              for (int j = 0; j < name_length; j++){
                start_col[j] = 255 + (j * 10); //give new letters slower anim speed
                rand_col[j] = random(.3,1); 
              }
              // println("4) "+i);
              fade_text_rand.set(i, rand_col);
              // println("5) "+i);
              fade_text.set(i, start_col);
              // println("6) "+i);
            }

          }
        } 
        //trigger animation
        for (int i = 0; i < text_names_list.size(); i++){
          String current_name = text_names_list.get(i);
          float[] current_fades = fade_text.get(i);
          float[] current_fades_rand = fade_text_rand.get(i);
          // set text size for each row
          if (i == 0) textSize(14-(i*1.5));
          float text_size = 11-(i*.5);
          if (text_size <= 6) text_size = 6;
          textSize(text_size);
          String word = new String();
          word = "";

          for (int j = 0; j<current_name.length(); j++){
            char c0 = current_name.charAt(j);
            String ch = new String();
            ch += c0;
            if (i == 0) ch = ch.toUpperCase();
            float speed_mod = text_fade_speed * current_fades_rand[j] ;
            current_fades[j] += EaseIn(current_fades[j], 128 + (i * 5), speed_mod);
            float ease_out_color = current_fades[j];
            fill(ease_out_color);
            text(ch, (marginX*2) + textWidth(word) + ((j*15)/(i+1)), marginY*2 + (i * 20));
            word += ch;
            if (c0 == ' ') word += " ";
          }
          fade_text.set(i, current_fades);
          fade_text_rand.set(i, current_fades_rand);
        }
    }

    fill(0);
    textAlign(LEFT);
    // text(out_name, marginX + 300, marginY + 10);
  }
  

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