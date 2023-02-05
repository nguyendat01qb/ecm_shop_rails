import "../lib/select2.min";

import Main from "./home/main";
import Product from "./products/product";
import Order from "./users/order";

// import "./products/product";

document.addEventListener("turbolinks:load", () => {
  const home = new Main();
  const product = new Product();
  const order = new Order();
});
