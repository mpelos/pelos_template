$(document).ready(function(){
  //ADD CHILD FIELDS
  $(function() {
    $('form a.add_child').click(function() {
      var association = $(this).attr('data-association');
      var template = $('#' + association + '_fields_template').html();
      var regexp = new RegExp('new_' + association, 'g');
      var new_id = new Date().getTime();

      $("#" + association + "_container").append(template.replace(regexp, new_id));
      return false;
    });

    $('form a.remove_child').live('click', function() {
      var hidden_field = $(this).prev('input[type=hidden]')[0];
      if(hidden_field) {
        hidden_field.value = '1';
      }
      $(this).parents('.fields').hide();
      return false;
    });
  });

  // FANCYBOX
  $('.expand_image').fancybox({
    'titleShow': false,
    'transitionIn': 'elastic',
    'transitionOut': 'elastic'
  });

  // WIGSIWYG
  $('.richtext').wysiwyg({
    controls: {
      bold: { tooltip: 'Negrito' },
      italic: { tooltip: 'Itálico'},
      strikeThrough: { tooltip: 'Tachado' },
      underline: { tooltip: 'Sublinhado' },
      justifyLeft: { tooltip: 'Alinhar Texto à Esquerda' },
      justifyCenter: { tooltip: 'Centralizar' },
      justifyRight: { tooltip: 'Alinhar Texto à Direita' },
      justifyFull: { tooltip: 'Justificar' },
      indent: { tooltip: 'Aumentar Recuo' },
      outdent: { tooltip: 'Diminuir Recuo' },
      subscript: { visible : false },
      superscript: { visible : false },
      undo: { tooltip: 'Desfazer' },
      redo: { tooltip: 'Restaurar' },
      insertOrderedList: { tooltip: 'Inserir Lista Ordenada' },
      insertUnorderedList: { tooltip: 'Inserir Lista Desordenada' },
      insertHorizontalRule: { visible: false },
      createLink: { tooltip: 'Criar Hiperlink' },
      insertImage: { tooltip: 'Inserir Imagem' },
      h1mozilla: { tooltip: 'Título 1' },
      h2mozilla: { tooltip: 'Título 2' },
      h3mozilla: { tooltip: 'Título 3' },
      h1: { tooltip: 'Título 1' },
      h2: { tooltip: 'Título 2' },
      h3: { tooltip: 'Título 3' },
      removeFormat: { tooltip: 'Remover Formatação' }
    }
  });
});

