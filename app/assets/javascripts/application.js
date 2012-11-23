// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require utils
//= require twitter/bootstrap
//= require jquery.wookmark.min
//= require jquery.elastic.source
//= require chosen-jquery
//= require categories
//= require jquery.remotipart
//= require_self


$(document).on(
    new function() {
    // Prepare layout options.
    var options = {
    autoResize: true, // This will auto-update the layout when the browser window is resized.
    container: $('#main'), // Optional, used for some extra CSS styling
    offset:20, // Optional, the distance between grid items
    itemWidth: 236 // Optional, the width of a grid item
    };

// Get a reference to your grid items.
var handler = $('.item');
    handler.imagesLoaded(function(){
        // Call the layout function.
        handler.wookmark(options);
    });
        var optionsForMember = {
            autoResize: true, // This will auto-update the layout when the browser window is resized.
            container: $('.member_grid'), // Optional, used for some extra CSS styling
            offset:4, // Optional, the distance between grid items
            itemWidth: 32 // Optional, the width of a grid item
        };
        var handlerGridItems = $('.grid_item');
        handlerGridItems.imagesLoaded(function(){
            // Call the layout function.
            handlerGridItems.wookmark(optionsForMember);
        });
// Capture clicks on grid items.
handler.click(function(){
    handler.wookmark();
    });

     $(".post_input textarea").elastic()



});

jQuery(window).ready(
    function() {
        jQuery('.notice').delay(6000).slideUp( 'slow');
        jQuery('.notice').delay(6000).slideUp( 'slow');
    }
);

