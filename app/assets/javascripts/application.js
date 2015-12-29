//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require autocomplete-rails
//= require_tree .
//= require_self

$(document).ready(function(){
  $('#product_category').val("babyp");
  $('.cat-btn').on("click", function(e){
      chosenCat = e.target.getAttribute("id");
      catArr = $(".cat-btn");

      $('.cat-btn').each(function(ind, obj) {
        obj.classList.remove("active");
      });

      $('#'+chosenCat).addClass("active");
      $('#product_category').val(chosenCat);
  });

 // $(".ui-autocomplete ").addClass("transition");

  

});
