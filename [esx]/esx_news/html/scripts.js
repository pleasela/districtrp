
let lol = false;
$(document).ready(function(){
  // Partial Functions
  function closeMain() {
    $(".app").css("display","none");
  }
  function openMain() { //hide parts of ui etc
	 
	$(".likeBtn").css("display","none");
	$(".news").css("display","none");
	$(".btnRet").css("display","none");
	
	
    $(".app").css("display","block");
	$("#datalistn").css("display","block"); 
	
  }
  function closeAll() {
    $(".app").css("display","none");
  }
  
  function addLikeStringNew(strink) {
	
	var toAdd = strink;
	$(".likes").html(toAdd);
	$(".likes").css("display","block");
	$(".likeBtn").css("display","none");
	
  }
  
  function addLikeString(strink) {
	
	$(".likes").html(strink);
	$(".likes").css("display","block");
	$(".likeBtn").css("display","none");
	
  }
  
  function openArticle(title, content, author, author_id, imgurl) {
	
	$(".btnRet").css("display","block"); //return button
	
	$("#datalistn").css("display","none"); //hide parts of ui
	$(".likeBtn").css("display","none");
	$(".likes").css("display","none");
	
	$(".likeBtn").attr("author_id", author_id); //set likebtn value
	$(".newstitle").html(title); //set news title
	$(".newscontent").html(content);//set news content
	$(".author").html("Author: " + author); //vaihda tämä
	$(".newsimg").attr("src", imgurl);
	//like button etc here
	
	  
	$(".news").css("display","block"); //display article
  }
  
  function showLoader(){
	$(".loader").css("display", "block");
	//$(".gtfo").fadeOut(300);
  }
  
  function hideLoader(){
	$(".loader").css("display", "none");
	//$(".gtfo").fadeIn(300);
  }
  
  // Listen for NUI Events
  window.addEventListener('message', function(event){

	var item = event.data;
	
	if(item.showLoader == true ) {
		showLoader();
	}
	if(item.hideLoader == true ) {
		hideLoader();
	}
	
    if(item.openNews == true) {
      
	  openMain();
    }
    
	if(item.openNews == false) {
	  
	  $("#datalistn").empty();
      closeMain();
	  $(".news").css("display","none"); //display articlelist
	  $(".likeBtn").css("display","none"); //display likebutton
	  $(".likes").css("display","none"); //display likes
	  
    }
	
	if(item.addLikes == true) {
		
		addLikeString(item.likes);
		$(".likeBtn").css("display","none");
		
    }
	
	if(item.addLikeButton == true) {
		
		$(".likeBtn").css("display","block");
		$(".likeBtn").attr("like_id", item.like_id);
		$(".likes").attr("likes", item.likes);
		
    }


    if(item.clearlist == true) { //clearitems
		
		$(".likeBtn").css("display","none");
	    $("#datalistn").empty(); //clear newslist
    }
	

    if(item.addNews == true) {
		
		var ul = document.getElementById("datalistn"); //get vehicle list
	     
		var li = document.createElement("li"); //create list element to add
		
		var text = document.createTextNode(item.bait_title);  //create textnode to be inserted
		text.className = ("titleb");
		
		li.className = ("litemn"); //set class
		
		li.appendChild(text); //add textnode
		li.setAttribute("content", item.content); //add custom attributes
		//li.setAttribute("content", item.author_id); //POISTA TÄMÄ
		li.setAttribute("title", item.title);
		li.setAttribute("author", item.author_name);
		li.setAttribute("author_id", item.author_id); 
		li.setAttribute("like_id", item.id);
		li.setAttribute("imgurl", item.imgurl); //imageurl
		
		ul.appendChild(li); //append to list  
    }
	
	$(".litemn").unbind().click(function(){ //on list item click
		
		showLoader();
		openArticle($(this).attr("title"), $(this).attr("content"), $(this).attr("author"), $(this).attr("author_id"), $(this).attr("imgurl"));
		$.post('http://esx_news/getLikes', JSON.stringify({id : $(this).attr("like_id")}));
		hideLoader();
		
    });

  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
   
   if (data.which == 27 ) {
      
	  $("#datalistn").empty();
	  $.post('http://esx_news/closeNews', JSON.stringify({}));
	  
    
	}
  };
  
   $(".btnClose").unbind().click(function(){
    
	$.post('http://esx_news/closeNews', JSON.stringify({}));
	  $("#datalistn").empty();
    
	});
	
	$(".index").click(function(){
		openMain();
	});
	
	$(".btnRet").click(function(){
		openMain();
	});
	
	$(".likeBtn").click(function(){
      
	  addLikeString($(".likeBtn").attr("likes"));
	  $(".likes").css("display", "block");
	  $.post('http://esx_news/likeArticle', JSON.stringify({id : $(this).attr("like_id"), author :  $(this).attr("author_id") }));
	  //$.post('http://esx_news/getLikes', JSON.stringify({id : $(this).attr("like_id")}));
		
    });
	

});
 