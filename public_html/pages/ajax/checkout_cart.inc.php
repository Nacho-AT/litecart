<?php
  if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    header('Content-type: text/html; charset='. language::$selected['charset']);
    document::$layout = 'ajax';
    header('X-Robots-Tag: noindex');
  }

  if (empty(cart::$items)) {
    echo '<p><em>'. language::translate('description_no_items_in_cart', 'There are no items in your cart.') .'</em></p>' . PHP_EOL
       . '<p><a href="'. document::href_ilink('') .'">&lt;&lt; '. language::translate('title_back', 'Back') .'</a></p>';
    return;
  }

  $box_checkout_cart = new ent_view();

  $box_checkout_cart->snippets = array(
    'items' => array(),
    'subtotal' => cart::$total['value'],
    'subtotal_tax' => cart::$total['tax'],
  );

  foreach (cart::$items as $key => $item) {
    $box_checkout_cart->snippets['items'][$key] = array(
      'product_id' => $item['product_id'],
      'link' => document::ilink('product', array('product_id' => $item['product_id'])),
      'thumbnail' => functions::image_thumbnail(FS_DIR_APP . 'images/' . $item['image'], 320, 320, 'FIT_USE_WHITESPACING'),
      'name' => $item['name'],
      'sku' => $item['sku'],
      'gtin' => $item['gtin'],
      'taric' => $item['taric'],
      'options' => array(),
      'display_price' => customer::$data['display_prices_including_tax'] ? $item['price'] + $item['tax'] : $item['price'],
      'price' => $item['price'],
      'tax' => $item['tax'],
      'tax_class_id' => $item['tax_class_id'],
      'quantity' => (float)$item['quantity'],
      'quantity_unit' => $item['quantity_unit'],
      'weight' => (float)$item['weight'],
      'weight_class' => $item['weight_class'],
      'dim_x' => (float)$item['dim_x'],
      'dim_y' => (float)$item['dim_y'],
      'dim_z' => (float)$item['dim_z'],
      'dim_class' => $item['dim_class'],
      'error' => $item['error'],
    );
  }

  echo $box_checkout_cart->stitch('views/box_checkout_cart');
