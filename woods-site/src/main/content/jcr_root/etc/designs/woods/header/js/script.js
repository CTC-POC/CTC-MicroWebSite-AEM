$(document).ready(function(){
	$(".search__input").on("keyup",function(){
		if($(this).val() == ""){
			$(".search__button").attr("disabled", true).css("background-color","#969696");
		}else{
		
		$(".search__button").attr("disabled", false).css("background-color","#64a70b");
            var serachKeyWord= $(this).val();
            console.log(serachKeyWord);
		}
	
	})
	$(window).resize(function(){
		if ($(this).width() < 1028) {
		
			$(".menu_dynamic.dropdown-toggle").removeClass("disabled");
		}
		else {
			$(".menu_dynamic.dropdown-toggle").addClass("disabled");
		}
	})
});