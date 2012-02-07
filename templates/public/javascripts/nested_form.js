jQuery(function($) {
  $('form a.add_nested_fields').live('click', function() {
    var assoc   = $(this).attr('data-association');
    var content = $('#' + assoc + '_fields_blueprint').html();

    var context = ($(this).closest('.fields').find('input:first').attr('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');

    if (context) {
      var parent_names = context.match(/[a-z_]+_attributes/g) || [];
      var parent_ids   = context.match(/[0-9]+/g);

      for(i = 0; i < parent_names.length; i++) {
        if(parent_ids[i]) {
          content = content.replace(
            new RegExp('(\\[' + parent_names[i] + '\\])\\[.+?\\]', 'g'),
            '$1[' + parent_ids[i] + ']'
          )
        }
      }
    }

    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();
    content     = content.replace(regexp, new_id);

    $(this).before(content);
    return false;
  });

  $('form a.remove_nested_fields').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];

    if (hidden_field) {
      hidden_field.value = '1';
    }

    $(this).closest('.fields').hide();
    return false;
  });
});

