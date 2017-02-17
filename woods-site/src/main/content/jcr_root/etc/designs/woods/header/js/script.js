(function( $ ) {
  $(function() {
    $( ".search__input" ).keyup(function() {

        if($(this).val().length <= 1) {
                $(".search__button").attr("disabled", true).css("background-color", "#969696");
             	$(".advanced_Search").attr("disabled", true)
            }
            else {
                $(".search__button").attr("disabled", false).css("background-color", "#64a70b");
                $(".advanced_Search").attr("disabled", false)
            }

    });

      $(".search__button" ).click(function() {
	       var search_value = $('.search__input').val();
			var search_path = $('#hybrisRedirectPath').val();
			console.log(search_value);
         	console.log(search_path);
          	window.location = search_path+"search/?text="+search_value;
      });
      $(".advanced_Search" ).click(function() {
	       var search_value = $('.search__input').val();
          var search_path = $('#hybrisRedirectPath').val();
			console.log(search_value);
          window.location = search_path+"elasticsearch/?text="+search_value;
      });


  });
})(jQuery);
