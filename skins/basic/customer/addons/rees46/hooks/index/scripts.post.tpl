{if $rees46 && $rees46.shop_id != ''}
  <script type="text/javascript">
{literal}
    function initREES46() {
      $(function () {
{/literal}
        {if $auth.user_id > 0}
          REES46.init('{$rees46.shop_id}', {$auth.user_id|default:'null'});
        {else}
          REES46.init('{$rees46.shop_id}', null);
        {/if}
{literal}
        if (!String.prototype.format) {
            String.prototype.format = function() {
                var args = arguments;
                return this.replace(/\[(\d+)\]/g, function(match, number) {
                    return typeof args[number] != 'undefined'
                        ? args[number]
                        : match
                        ;
                });
            };
        }
{/literal}
        {if $product}
          document.currentProductId = {$product.product_id};
        {/if}

        {if $cart}
          document.currentCart = '{$cart.products|json_encode}';
          document.currentCart = document.currentCart.replace(/&quot;/g, '"');
          document.currentCart = JSON.parse(document.currentCart);
          var ids = [];
{literal}
          for(var k in document.currentCart) {
            ids.push(document.currentCart[k].product_id);
          }
{/literal}
          document.currentCart = ids;
        {else}
          document.currentCart = [];
        {/if}
{literal}
        REES46.addReadyListener(function() {
          var link = document.createElement('link');
          link.setAttribute('rel', 'stylesheet');
          link.setAttribute('type', 'text/css');
          link.setAttribute('href', '//rees46.com/shop_css/{$rees46.shop_id}');
          document.getElementsByTagName('head')[0].appendChild(link);
{/literal}
          {if $controller == 'products' && $mode == 'view'}
            {if $product}
{literal}
              REES46.pushData('view', {
{/literal}
                  item_id: {$product.product_id},
                  price: {$product.base_price},
                  {if $product.amount > 0}
                  is_available: true,
                  {else}
                  is_available: false,
                  {/if}
                  category: {$product.main_category},
                  name: '{$product.product}',
                  url: '{"products.view?product_id=`$product.product_id`"|fn_url}',
                  image_url: '{$product.main_pair.detailed.image_path}'
{literal}
              });
{/literal}
            {/if}
          {/if}
{literal}
          $('.rees46').each(function() {
{/literal}
            var recommenderBlock = $(this);
            var recommenderType = recommenderBlock.attr('data-type');
            var categoryId = recommenderBlock.attr('data-category');

            var tpl_items = '<div class="recommender-block-title">[1]</div><div class="recommended-items">[0]</div>';
            var tpl_item  = '<div class="recommended-item">'+
                            '<div class="recommended-item-photo">'+
                                '<a href="[0]"><img src="[2]" class="item_img" /></a>'+
                            '</div>'+
                            '<div class="recommended-item-title">'+
                                '<a href="[0]">[1]</a>'+
                            '</div>'+
                            '<div class="recommended-item-price">'+
                                '[3] [4]'+
                            '</div>'+
                            '<div class="recommended-item-action">'+
                                '<a href="[0]">Подробнее</a>'+
                            '</div>'+
                       '</div>';

{literal}
            if (recommenderType) {
              REES46.recommend({
                recommender_type: recommenderType,
                category: categoryId,
                item: document.currentProductId,
                cart: document.currentCart
              }, function(ids) {
                if (ids.length == 0) {
                  return;
                }

                $.getJSON('index.php?dispatch=rees46.get_info&product_ids=' + ids.join(','), function(data) {
                  var products = JSON.parse(data.text).products;

                  var productsBlock = '';

                  $(products).each(function() {
                    if (this.name != '') {
                      var url = '';

                      if (this.url.lastIndexOf('?') > 0) {
                        url = this.url + '&';
                      } else {
                        url = this.url + '?';
                      }

                      productsBlock += tpl_item.format(
                        url + 'recommended_by=' + recommenderType,
                        this.name,
                        this.image_url,
                        this.price,
                        REES46.currency
                      );
                    }
                  });

                  var recommender_titles = {
                      interesting: 'Вам это будет интересно',
                      also_bought: 'С этим также покупают',
                      similar: 'Похожие товары',
                      popular: 'Популярные товары',
                      see_also: 'Посмотрите также',
                      recently_viewed: 'Вы недавно смотрели'
                  };

                  if (productsBlock != '') {
                    items = tpl_items.format(productsBlock, recommender_titles[recommenderType]);

                    if (REES46.showPromotion) {
                        items = items + REES46.getPromotionBlock();
                    }

                    recommenderBlock.html(items);
                  }
                });
              });
            }
          });
        });
      });
    }

    var script = document.createElement('script');
    script.src = '//cdn.rees46.com/rees46_script2.js';
    script.async = true;
    script.onload = function() {
      initREES46();
    };
    document.getElementsByTagName('head')[0].appendChild(script);
  </script>
{/literal}
{/if}
