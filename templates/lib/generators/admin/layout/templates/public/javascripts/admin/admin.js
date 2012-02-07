$(document).ready(function(){
  //SET SELECTED ITEM IN MENU
  $(selected).addClass('selected');

  //HIDE NOTICES
  setTimeout(function() {
    $('p.notice').slideUp('fast');
  }, 3000);

  // LIST SORTABLE
  $(function() {
		$('.sortable').sortable({
		  handle: '.move',
			placeholder: "ui-state-highlight",
	    stop: function(event, ui){
        $.post($(ui.item).attr("data-reorder-path"), {
          "position": ui.item.prevAll(".item").length + 1
        });
      }
		});

		$('.items').disableSelection();
	});

  // FORM THUMBS
  $('.thumb').hover(
    function(){
      $(this).children('a').children('img').fadeTo('fast', 1.0);
      $(this).children('a.cross').show();
    },
    function(){
      $(this).children('a').children('img').fadeTo('fast', 0.8);
      $(this).children('a.cross').hide();
    }
  );

  //TOOLTIP
  $(".tooltip").tooltip({
    position: "center right",
    offset: [-2, 10],
    effect: "fade",
    opacity: 0.7
  });

  // FANCYBOX
  $('.expand_image').fancybox({
    'titleShow':  false,
    'cyclic':     true
  });

  $('.show').fancybox({
    'width': 960,
    'titleShow':  false,
    'autoScale': false,
    'type': 'iframe'
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

