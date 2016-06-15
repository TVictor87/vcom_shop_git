// page init
jQuery(function(){
    $('.warning-block').hide();
    $('.list-buttons a').each(function(){
        var element = $(this);
        if(element.data('rel') != ''){
            element.on('click', function(e){
                e.preventDefault();
                var block = $('#' + element.data('rel'));
                setTimeout(function(){
                    block.slideUp();
                },7000);
                block.slideDown();
                block.find('.close').on('click', function(e){
                    e.preventDefault();
                    block.slideUp();
                })
            });

        }
    });
    initTabs();
    checkSize();
    $(window).resize(checkSize);
    initCarousel();
    jcf.customForms.replaceAll();
    initLightbox();
    initOpenClose();

    jQuery('.spinner').spinner({spin: function(event, ui) {
        if (ui.value < 1) {
            jQuery(this).spinner("value", 1);
            return false;
        }
    }
    });

    var cart = $('#popup-cart');
    var steps = cart.find('.form-popup-cart fieldset>div');
    steps.each(function(index){
        var element = $(this);
        if(index == steps.length - 1){

        }
        else{
            element.find('a.button').on('click', function(e){
                e.preventDefault();
                element.hide();
                steps.eq(index + 1).show();
            })
        }
    });


    $('#price').change(function () {
        var val = $(this).val();
        $('#slider_price').slider("values",0,val);
    });
    $('#price2').change( function() {
        var val2 = $(this).val();
        $('#slider_price').slider("values",1,val2);
    });
    $( "#slider_price" ).slider({
        range: true,
        min: 0,
        step:50,
        max: 400,
        values: [ 50, 300 ],
        slide: function( event, ui ) {
            $('#price').val(ui.values[0]);
            $('#price2').val(ui.values[1]);
        }
    });
});

function checkSize(){
    if ($("#sidebar").css("float") == "none" ){
        $( 'ul.accordion li' ).removeClass( "active" );
    }
}

// open-close init
function initOpenClose() {
    jQuery('#nav').openClose({
        activeClass: 'active',
        opener: '.opener',
        slider: '.slide-block',
        hideOnClickOutside: true,
        hideOnSlideClick: false,
        animSpeed: 600,
        effect: 'slide'
    });
    jQuery('.slide-holder').openClose({
        activeClass: 'active',
        opener: '>.opener',
        slider: '.slide-block',
        hideOnClickOutside: true,
        hideOnSlideClick: false,
        animSpeed: 600,
        effect: 'slide'
    });
    jQuery('ul.accordion li').openClose({
        activeClass: 'active',
        opener: '.opener',
        slider: 'div.slide',
        hideOnClickOutside: false,
        hideOnSlideClick: false,
        animSpeed: 600,
        effect: 'slide'
    });
}

// scroll gallery init
function initCarousel() {
    jQuery('div.carousel').scrollGallery({
        mask: 'div.mask',
        slider: 'div.slideset',
        slides: 'div.slide',
        btnPrev: 'a.btn-prev',
        btnNext: 'a.btn-next',
        stretchSlideToMask: true,
        pagerLinks: '.pagination li',
        autoRotation: false,
        switchTime: 3000,
        animSpeed: 500,
        step: 1
    });
}


// content tabs init
function initTabs() {
    jQuery('ul.tabset').contentTabs({
        tabLinks: 'a'
    });
    jQuery('ul.tabset-popup').contentTabs({
        tabLinks: 'a'
    });
}

// fancybox modal popup init
function initLightbox() {
    jQuery('a.lightbox-open, a[data-rel*="lightbox"]').each(function(){
        var link = jQuery(this);
        link.attr('rel', link.attr('data-rel')).fancybox({
            padding: 0,
            cyclic: false,
            overlayShow: true,
            overlayOpacity: 0.6,
            overlayColor: '#000',
            titlePosition: 'inside',
            onComplete: function(box) {
                if(link.attr('href').indexOf('#') === 0) {
                    jQuery('#fancybox-content').find('a.close').unbind('click.fb').bind('click.fb', function(e){
                        jQuery.fancybox.close();
                        e.preventDefault();
                    });
                }
            }
        });
    });
}