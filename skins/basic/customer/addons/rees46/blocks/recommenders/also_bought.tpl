{** block-description:rees46_also_bought **}

{if $product}
  <div class="rees46 rees46-recommend" data-type="also_bought" data-id="{$product.product_id}"></div>
{else}
  <script type="text/javascript">
    alert('Рекомендер REES46 "С этим также покупают" должен быть расположен на странице товара. На данной странице информации о товаре не обнаружено');
  </script>
{/if}