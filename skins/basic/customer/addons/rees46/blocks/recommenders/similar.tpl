{** block-description:rees46_similar **}

{if $product}
  <div class="rees46 rees46-recommend" data-type="similar" data-id="{$product.product_id}"></div>
{else}
  <script type="text/javascript">
    alert('Рекомендер REES46 "Похожие товары" должен быть расположен на странице товара. На данной странице информации о товаре не обнаружено');
  </script>
{/if}
