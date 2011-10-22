$(document).ready(function () {
  $('select#year').change(function () {
        document.location.pathname = '/budget/' + $(this).val();
  });
});
