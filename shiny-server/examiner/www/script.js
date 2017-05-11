// Trigger Shiny to re-calculate ONLY AFTER mouse is up
// This is to help create a reactive framework, while at 
// the same time ensure that RStudio doesn't crash
$(document).ready(function(){
  
  // Create a variable that holds the event
  var sliderMouseUp;
  
  // After a user triggers a mouse up (after mouse down)
  // Wait for 1.5 seconds before triggering the request
  $('.row').mouseup(function() {
    sliderMouseUp = setTimeout(function() {
      
      // Trigger a random request. Shiny simply
      // Needs to be notified that something changed
      // Documentation: https://github.com/daattali/advanced-shiny/tree/master/message-javascript-to-r
      var number = Math.random();
      Shiny.onInputChange("js_trigger", number);
    }, 1500);
    
  });
  
  // If the user clicks within the duration of the
  // setTimeout. Restart again
  $('.slider').mousedown(function() {
    if (sliderMouseUp) {
      clearTimeout(sliderMouseUp);
    }
  });
  
}) // End of document.ready and mouseup trigger



// Plethora of slider handles :D

$("#fixed_acidity").slider();
$("#fixed_acidity").on("slide", function(slideEvt) {
  $("#fixed_acidity_value").text(slideEvt.value);
});

$("#volatile_acidity").slider();
$("#volatile_acidity").on("slide", function(slideEvt) {
  $("#volatile_acidity_value").text(slideEvt.value);
});

$("#citric_acid").slider();
$("#citric_acid").on("slide", function(slideEvt) {
  $("#citric_acid_value").text(slideEvt.value);
});

$("#residual_sugar").slider();
$("#residual_sugar").on("slide", function(slideEvt) {
  $("#residual_sugar_value").text(slideEvt.value);
});

$("#chlorides").slider();
$("#chlorides").on("slide", function(slideEvt) {
  $("#chlorides_value").text(slideEvt.value);
});

$("#density").slider();
$("#density").on("slide", function(slideEvt) {
  $("#density_value").text(slideEvt.value);
});

$("#alcohol").slider();
$("#alcohol").on("slide", function(slideEvt) {
  $("#alcohol_value").text(slideEvt.value);
});

$("#total_sulfur_dioxide").slider();
$("#total_sulfur_dioxide").on("slide", function(slideEvt) {
  $("#total_sulfur_dioxide_value").text(slideEvt.value);
});

$("#free_sulfur_dioxide").slider();
$("#free_sulfur_dioxide").on("slide", function(slideEvt) {
  $("#free_sulfur_dioxide_value").text(slideEvt.value);
});

$("#pH").slider();
$("#pH").on("slide", function(slideEvt) {
  $("#ph_value").text(slideEvt.value);
});

$("#sulphates").slider();
$("#sulphates").on("slide", function(slideEvt) {
  $("#sulphates_value").text(slideEvt.value);
});