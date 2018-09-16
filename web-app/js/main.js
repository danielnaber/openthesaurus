$(function() {
    var header = $('.header');
    var burger = $('.header-burger');
    var menu = $('.header-menu');

    burger.on('click', toggleMenu);

    function toggleMenu() {
        if (header.hasClass('menu-open')) {
            menu.slideUp(function() {
                header.removeClass('menu-open');
                menu.css('display', '');
            });
        } else {
            menu.slideDown(function() {
                menu.css('display', '');
            });
            header.addClass('menu-open');
        }
    }
});
