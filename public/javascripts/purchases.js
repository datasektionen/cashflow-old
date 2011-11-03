var Purchase = {
  setupBudgetPostSelect: function(budgetPosts, businessUnitSelect, budgetPostsSelect) {
    this.businessUnitSelect = businessUnitSelect;
    this.budgetPostsSelect = budgetPostsSelect;
    this.budgetPosts = budgetPosts;
    $(businessUnitSelect).change(Purchase.loadBudgetPosts);
    $(businessUnitSelect).trigger('change');
  },
  loadBudgetPosts: function() {
    var      newHtml = "",
        businessUnit = $(Purchase.businessUnitSelect).val();
    if (businessUnit) {
      var array = Purchase.budgetPosts[businessUnit];
      if (array) {
        $.each(Purchase.budgetPosts[businessUnit],function(index, bp) {
          var   id = bp.budget_post.id,
              name = bp.budget_post.name;
          newHtml += "<option value='"+ id +"'>"+ name +"</option>";
        });
      }
    }
    $(Purchase.budgetPostsSelect).html(newHtml);
  }
};
