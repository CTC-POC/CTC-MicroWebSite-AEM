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
      $(".search__button, .advanced_Search" ).click(function() {
	       var search_value = $('.search__input').val();
			console.log(search_value);
          window.location ="https://10.226.179.82:9002/ctcstorefront/en/search/?text=woods";
      });

  });
})(jQuery);
