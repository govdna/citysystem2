function deperSort () {
    var NUM = 6;
    var deper = $('#deper');

    deper.find(' span').each(function(index) {
        if (index && index % NUM == 0) {
            $(this).after('<br>');
        }
    });
  deper.css('marginLeft', -deper.width() / 2);
}