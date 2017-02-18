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
	       var search_value = $('.search__input').val();
			var search_path = $('#hybrisRedirectPath').val();
			console.log(search_value);
         	console.log(search_path);
          	window.location = search_path+"search/?text="+search_value;
      });
        }
      else{
      $(".search__button" ).click(function() {
	       var search_value = $('.search__input').val();
          var search_path = $('#hybrisRedirectPath').val();
			console.log(search_value);
          window.location = search_path+"elasticsearch/?text="+search_value;
      });
      }
		$(window).resize(function(){
		if ($(this).width() < 1028) {
			$(".menu_dynamic.dropdown-toggle").removeClass("disabled");
			
		}
		else {
			$(".menu_dynamic.dropdown-toggle").addClass("disabled");
		}
	})
		if ($(this).width() < 1028) {
			$(".menu_dynamic.dropdown-toggle").removeClass("disabled");
		}
		else {
			$(".menu_dynamic.dropdown-toggle").addClass("disabled");
		}
		
        $('.dropdown-submenu a').on("click", function(e) {
		if($(window).width() < 1028) {
            $(this).next('ul').toggle();
            $(this).find('.glyphicon').toggleClass("down");
            e.stopPropagation();
            e.preventDefault();
			}
        })

  });
})(jQuery);
