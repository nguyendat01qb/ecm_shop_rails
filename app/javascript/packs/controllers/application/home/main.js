import '../../lib/jquery.scrollUp.min';

export default class MainController {
  constructor() {
    this.handleLoader();
    this.handleScrollUp();
    this.showIconCart();
  }

  handleLoader = () => {
    $('#loader').fadeOut('slow');
    $('.show_body').css('display', 'block');
  };

  handleScrollUp = () => {
    $(() => {
      $.scrollUp({
        scrollName: 'scrollUp', // Element ID
        scrollDistance: 300, // Distance from top/bottom before showing element (px)
        scrollFrom: 'top', // 'top' or 'bottom'
        scrollSpeed: 300, // Speed back to top (ms)
        easingType: 'linear', // Scroll to top easing (see http://easings.net/)
        animation: 'fade', // Fade, slide, none
        animationSpeed: 200, // Animation in speed (ms)
        scrollTrigger: false, // Set a custom triggering element. Can be an HTML string or jQuery object
        //scrollTarget: false, // Set a custom target element for scrolling to the top
        scrollText: "<i class='fa fa-angle-up'></i>", // Text for element, can contain HTML
        scrollTitle: false, // Set a custom <a> title if required.
        scrollImg: false, // Set true to use image
        activeOverlay: false, // Set CSS color to display scrollUp active point, e.g '#00FFFF'
        zIndex: 2147483647, // Z-Index for the overlay
      });
    });
  };

  showIconCart = () => {
    const product_ids = _.uniq(_.map(JSON.parse(localStorage.getItem('carts')), function(attr) { return attr.product_id}))
    $('.count-product').get(0).innerText = product_ids.length > 0 ? product_ids.length : '';
  };
}
