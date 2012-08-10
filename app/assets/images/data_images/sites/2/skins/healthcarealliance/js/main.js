
// For Input Forms
function clearText(field) {

    if (field.defaultValue == field.value) field.value = '';
    else if (field.value == '') field.value = field.defaultValue;

}



// ACCORDION


$(document).ready(function(){
	
//Set default open/close settings
$('.modules .block-content').hide(); //Hide/close all containers
$('.modules').find('h3').addClass('modules-trigger');
//On Click
$('.modules-trigger').click(function(){
	if( $(this).next().is(':hidden') ) { //If immediate next container is closed...
		$('.modules-trigger').removeClass('active').next().slideUp(); //Remove all .acc_trigger classes and slide up the immediate next container
		$(this).toggleClass('active').next().slideDown(); //Add .acc_trigger class to clicked trigger and slide down the immediate next container
	}
	else {
		$(this).next().slideUp()
		$('.modules-trigger').removeClass('active').next().slideUp();
	}
	return false; //Prevent the browser jump to the link anchor
});

});