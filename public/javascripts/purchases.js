var Purchase = {
  setupBudgetPostSelect: function(budgetPosts, businessUnitSelect, budgetPostsSelect) {
    this.businessUnitSelect = businessUnitSelect;
    this.budgetPostsSelect = budgetPostsSelect;
    this.budgetPosts = budgetPosts;
    $(businessUnitSelect).change(Purchase.loadBudgetPosts);
  },
  loadBudgetPosts: function() {
    var newHtml = "";
    var businessUnit = $(Purchase.businessUnitSelect).val();
    if (businessUnit) {
      var array = Purchase.budgetPosts[businessUnit];
      if (array) {
        $.each(Purchase.budgetPosts[businessUnit],function(index, bp) {
          newHtml += "<option value='"+bp.id+"'>"+bp.name+"</option>";
        });
      }
    }
    $(Purchase.budgetPostsSelect).html(newHtml);
  }
};
