{** block-description:rees46_popular **}

{if $category_data}
  <div class="rees46 rees46-recommend" data-type="popular" data-category="{$category_data.category_id}"></div>
{else}
  <div class="rees46 rees46-recommend" data-type="popular"></div>
{/if}
