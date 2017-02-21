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

      var elasticSearch=$('#elasticSearch').val();
	console.log(elasticSearch);
		if(!elasticSearch)
        {
      $(".search__button" ).click(function() {
          if ($(window).width() > 1028) {
			var search_value = $('.search__input').val();
			var search_path = $('#hybrisRedirectPath').val();
            var queryParam=$('#queryparameter').val();
          	window.location = search_path+"search/?text="+search_value+queryParam;
          }else{
			var search_value = $('.search_sm .search__input').val();
			var search_path = $('#hybrisRedirectPath').val();
            var queryParam=$('#queryparameter').val();
            window.location = search_path+"search/?text="+search_value+queryParam;
          }
      });
        }
      else{
      $(".search__button" ).click(function() {
			var search_value = $('.search__input').val();
			var search_path = $('#hybrisRedirectPath').val();
			var queryParam=$('#queryparameter').val();
          window.location = search_path+"elasticsearch/?text="+search_value+queryParam;
      });
      }
		
        $('.dropdown-submenu>a').on("click", function(e) {
		if($(window).width() < 1028) {
            $(this).next('ul').toggle();
            $(this).find('.glyphicon').toggleClass("down");
            e.stopPropagation();
            e.preventDefault();
			}
        })

  });
})(jQuery);
