void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  currCameraMatrix = new PMatrix3D(p3d.camera);
  perspective(PI/3., float(width)/float(height), 1/10.0, 10000.0);
  camera();
  if(show_hud==true){
    cp5.draw(); //DRAW CONTROLS AFTER CAMERA FOR GREAT SUCCESS
  }
  p3d.camera = currCameraMatrix;
  

  ///////////////////////////////////////////////////////////////////////
  // D I S P L A Y   N A M E S
  ///////////////////////////////////////////////////////////////////////
  textFont(font1);
  textAlign(RIGHT);
  if (show_text==true){
    if (selected_branch.name != "trunk"&&selected_branch.name != null) {
      if (display_name != selected_branch.name || update_text == true){
        
          fade_text.clear();
          fade_text_rand.clear();
          text_names_list.clear();
          display_name = selected_branch.name;
          Branch b = selected_branch;

          if (b.parent != null){
            for (int i = 0; i < text_list_size; i++) {
              if (b.name.equals("") == true) {
                while(b.name.equals("") == true){
                  b = b.parent;
                }
              }
              text_names_list.add(new String());
              text_names_list.set(i, b.name);
              int name_length = b.name.length();
              fade_text.add(new float[name_length]);
              fade_text_rand.add(new float[name_length]);
              
              b = b.parent;

              if (b.name == "trunk"||b.name=="null"||b.name==null) {
                text_names_list.remove(i);
                break;
              }

              }
              for (int i = 0; i < text_names_list.size(); i++) {
                int name_length = text_names_list.get(i).length();
                float[] start_col = new float[name_length];
                float[] rand_col = new float[name_length];

                for (int j = 0; j < name_length; j++){
                  start_col[j] = 255 + (j * 10); //give new letters slower anim speed
                  rand_col[j] = random(.3,1); 
                }
                fade_text_rand.set(i, rand_col);
                fade_text.set(i, start_col);
              }

            }
            update_text = false;
          
        } 
        //display text & animate
        for (int i = 0; i < text_names_list.size(); i++){
          String current_name = text_names_list.get(i);
          float[] current_fades = fade_text.get(i);
          float[] current_fades_rand = fade_text_rand.get(i);
          // set text size for each row
          if (i == 0) textSize(22-(i*1.5));
          float text_size = 18-(i*2);
          if (text_size <= 10) text_size = 10;
          textSize(text_size);
          String word = new String();
          word = "";

          for (int j = 0; j<current_name.length(); j++){
            char c0 = current_name.charAt(j);
            String ch = new String();
            ch += c0;
            if (i == 0) ch = ch.toUpperCase();

            float speed_mod = text_fade_speed * current_fades_rand[j] ;
            current_fades[j] += EaseIn(current_fades[j], 30 + (i * 5), speed_mod);
            float ease_out_color = current_fades[j];
            fill(ease_out_color, 255-ease_out_color);

            float y_offset = marginY*2+(i*20);
            if (i>0) y_offset += 8;
            // Add indentation
            String spacing = "";
            int spacing_max = int(i*1.5);
            if (spacing_max>=7) spacing_max=7;
            if (i==1) {
              if(j==0) spacing+= arrow + " ";
              word += spacing;
            }
            if (i>1) {
              if (j==0){
                for (int sp=0; sp<spacing_max; sp++){
                  // spacing += " ";
                }
                spacing += arrow + " ";
                word += spacing;
              }
            }
            word += ch;
            // if (i==0&&j==0) text(hover_id, marginX*3, height-200); //display id at bottom
            if (c0 == ' ') word += " ";
            if (i>0&&j==0) text(arrow + " " + ch, (marginX*3) + textWidth(word) + ((j*15)/(i+1)), y_offset);
            else text(ch, (marginX*3) + textWidth(word) + ((j*12)/(i+1)), y_offset);

          }
          fade_text.set(i, current_fades);
          fade_text_rand.set(i, current_fades_rand);
        }
    }
  }
    ///////////////////////////////////////////////////////////////////////
    // T I T L E
    ///////////////////////////////////////////////////////////////////////
    String word = new String();
    word = "";
    textFont(font3);
    textAlign(LEFT);
    pushMatrix();
      translate(width - (textWidth(title)*3.),0,0);
      for (int i = 0; i < title.length(); i++){
        char c0 = title.charAt(i);
        String ch = new String();
        ch += c0;
        ch = ch.toUpperCase();

        float title_speed_mod = 0.025 * title_fade_rand[i] ;
        
        //fade in
        if (frameCount < title_display_time){
          title_fade[i] += EaseIn(title_fade[i], 5 + (title_fade_rand[i]*16), title_speed_mod);
          float ease_out_color = title_fade[i];
          fill(ease_out_color, 255-ease_out_color);
          if (title_fade[i]<= 20) title_fade[i]=20;
          float x_pos = (marginX*2) + textWidth(word) + (i*15);
          float y_pos = marginY*2;
          text(ch, x_pos, y_pos);
          word += ch;
          if (c0 == ' ') word += " ";
        
          }
        //fade out
        else if (frameCount >= title_display_time) {
            title_fade[i] += EaseIn(title_fade[i], 255, title_speed_mod);
            if (title_fade[i]>= 255) title_fade[i]=255;
            float ease_out_color = title_fade[i];
            fill(ease_out_color, 255-ease_out_color);
            if (title_fade[i]<= 20) title_fade[i]=20;
            float x_pos = (marginX*2) + textWidth(word) + (i*15);
            float y_pos = marginY*2;
            text(ch, x_pos, y_pos);
            word += ch;
            if (c0 == ' ') word += " ";
          }
      }
    popMatrix();
    
    ///////////////////////////////////////////////////////////////////////
    // subtitle
    ///////////////////////////////////////////////////////////////////////
    textAlign(RIGHT);
    textFont(font2);
    fill(title_fade[0]+50, 255-title_fade[0]);
    text(subtitle, width - (marginX*2) - textWidth(title) - 30, (marginY*2)+20);

    ///////////////////////////////////////////////////////////////////////
    // help menu
    ///////////////////////////////////////////////////////////////////////
    textAlign(RIGHT);
    textFont(font2);
    if (display_help!=-1){
    if (frameCount >= display_help_delay) {
      help_dialog_fade += EaseIn(help_dialog_fade, 140, ease_speed*.2);
      if (help_dialog_fade <= 140) help_dialog_fade = 140;
    }
    if (frameCount >= display_help_delay+display_help_timer) {
      display_help = 0;
      display_help_delay = 2000000000;
    }
    else if (display_help==1 && help_dialog_fade >= 139) {
      help_dialog_fade += EaseIn(help_dialog_fade, 140, ease_speed*.7);
      if (help_dialog_fade<=140) help_dialog_fade=140;
    }
    else if (display_help==0 && help_dialog_fade <= 254) {
      help_dialog_fade += EaseIn(help_dialog_fade, 255, ease_speed*.7);
      if (help_dialog_fade>=255) {
        help_dialog_fade=255;
        display_help=-1;
      }
    }
    for (int i=0; i<help_dialog.length; i+=2){
      float x_offset = width - (marginX*2) - textWidth(title) - 30;
      float y_offset = (i * 7) + (marginY*2)+45;
      fill(help_dialog_fade, 255-(help_dialog_fade+1));
      if (i==0) text(help_dialog[i], width - (marginX*2) - textWidth(title) - 30, y_offset);
      else {
        fill((help_dialog_fade/255)*help_dialog_fade, 255-(help_dialog_fade+1));
        text(help_dialog[i-1], x_offset, y_offset);
        fill(help_dialog_fade, 255-(help_dialog_fade+1));
        text(help_dialog[i], x_offset - 10 - textWidth(help_dialog[i-1]), y_offset);
      }
    }
    }


  // }
  

}

void setupGUI() {

  ///////////////////////////////////////////////////////////////////////
  // Sliders
  ///////////////////////////////////////////////////////////////////////


  cp5 = new ControlP5(this); 
  // cp5.setControlFont(fontSliders);
  color invert_bg = color(255-red(bg_color),255-green(bg_color),255-blue(bg_color));
  cp5.setColorLabel(invert_bg);
  hud_offset = height - (19*14);

  cp5.addSlider("halo displace")
  .setPosition(marginX, marginY+(2*hud_spacing)+hud_offset)
  .setRange(0.001f, 0.5f)
  .setValue(0.06)
  .setSize(230,9)
  .setLabelVisible(true)
  ;
  cp5.addSlider("main stroke w")
  .setPosition(marginX, marginY+(3*hud_spacing)+hud_offset)
  .setRange(0.1, 10.0)
  .setValue(.7)
  .setSize(230,9)
  ;
  cp5.addSlider("halo stroke w")
  .setPosition(marginX, marginY+(4*hud_spacing)+hud_offset)
  .setRange(0.1, 10.0)
  .setValue(1.4)
  .setSize(230,9)
  ;
  cp5.addSlider("grow dir mult")
  .setPosition(marginX, marginY+(5*hud_spacing)+hud_offset)
  .setRange(0.01, 1.0)
  .setValue(.1)
  .setSize(230,9)
  ;  
  cp5.addSlider("perturb mult")
  .setPosition(marginX, marginY+(6*hud_spacing)+hud_offset)
  .setRange(0.01, 2.0)
  .setValue(1.81)
  .setSize(230,9)
  ;  
  cp5.addSlider("thickness offset")
  .setPosition(marginX, marginY+(7*hud_spacing)+hud_offset)
  .setRange(0.0, 2.0)
  .setValue(.23)
  .setSize(230,9)
  ;  
  cp5.addSlider("thickness random")
  .setPosition(marginX, marginY+(8*hud_spacing)+hud_offset)
  .setRange(0.0, 10.0)
  .setValue(1.0)
  .setSize(230,9)
  ;  
  cp5.addSlider("length mult")
  .setPosition(marginX, marginY+(9*hud_spacing)+hud_offset)
  .setRange(0, 6.0)
  .setValue(3.05)
  .setSize(230,9)
  ;
  cp5.addSlider("anim speed")
  .setPosition(marginX, marginY+(10*hud_spacing)+hud_offset)
  .setRange(0, 10.0)
  .setValue(1.)
  .setSize(230,9)
  ;
  cp5.addSlider("color r")
  .setPosition(marginX, marginY+(11*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.06)
  .setSize(230,9)
  ;  
  cp5.addSlider("color g")
  .setPosition(marginX, marginY+(12*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.05)
  .setSize(230,9)
  ; 
  cp5.addSlider("color b")
  .setPosition(marginX, marginY+(13*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.03)
  .setSize(230,9)
  ;
  cp5.addSlider("color rand")
  .setPosition(marginX, marginY+(14*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(.19)
  .setSize(230,9)
  ;


  cp5.addSlider("highlight r")
  .setPosition(marginX, marginY+(15*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.93)
  .setSize(230,9)
  ;  
  cp5.addSlider("highlight g")
  .setPosition(marginX, marginY+(16*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.09)
  .setSize(230,9)
  ; 
  cp5.addSlider("highlight b")
  .setPosition(marginX, marginY+(17*hud_spacing)+hud_offset)
  .setRange(0, 1.0)
  .setValue(0.18)
  .setSize(230,9)
  ;
  cp5.addSlider("gain")
  .setPosition(marginX, marginY+(18*hud_spacing)+hud_offset)
  .setRange(0, 5.0)
  .setValue(1.6)
  .setSize(230,9)
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
    base_cR = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("color g"))) {
    base_cG = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("color b"))) {
    base_cB = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("color rand"))) {
    spare_slider11 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("length mult"))) {
    spare_slider12 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("anim speed"))) {
    spare_slider13 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("highlight r"))) {
    spare_slider8 = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("highlight g"))) {
    spare_slider9 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("highlight b"))) {
    spare_slider10 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("gain"))) {
    gain = theEvent.getController().getValue();
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