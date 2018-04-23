$(function() {

    var header = $('.header');
    var burger = $('.header-burger');

    burger.on('click', toggleMenu);

    function toggleMenu() {
        header.toggleClass('menu-open');
    }

});
