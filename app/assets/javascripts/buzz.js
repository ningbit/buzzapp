(function($){

	$(document).ready(function(){

		var $body = $('body'),
			$buzzer = $('#buzzer'),
			$form = $('#form'),
			timer = true,
			queryName = getQueryVariable('name'),
			queryTeam = getQueryVariable('team'),
			DELAY = 3000;

		function buzz(status) {

			var buzzClass,
				buzzMessage;

			if ( status === 'success') {

				buzzClass = 'buzzed-in';
				buzzMessage = 'success!';

			} else if ( status === 'fail') {

				buzzClass = 'buzzed-in-fail';
				buzzMessage = 'too slow!';

			} else if ( status === 'wait') {

				buzzClass = 'buzzed-in-wait';
				buzzMessage = 'wait for game to start';
			}

			$body.addClass(buzzClass);
			$buzzer.html(buzzMessage);

			setTimeout(function(){
				$body.removeClass(buzzClass);
				$buzzer.html('buzz');
			},DELAY);
		}

		function bindBuzzer() {
			$buzzer.on('click', function(e){
				console.log('click');

				e.preventDefault();

				if( !$body.hasClass('buzzed-in') && !$body.hasClass('buzzed-in-fail') ){
					$form.submit();
				}
			});
		}

		function getQueryVariable(variable) {
			var query = window.location.search.substring(1);
			var vars = query.split("&");
			for ( var i=0; i < vars.length; i++ ) {
				var pair = vars[i].split("=");
				if( pair[0] == variable ){
					return pair[1];
				}
			}
			return(false);
		}

		function appendLinks(queryString){

			$('a').each(function(){

				var $link = $(this),
					href = $link.attr('href').split("?")[0],
					newHref = href + queryString;

				$link.attr('href',newHref);

			});
		}

		$form.submit(function(e) {

			var postData = $(this).serializeArray();
			var formURL = $(this).attr("action");
			$.ajax({
				url : formURL,
				type: "POST",
				data : postData,

			}).done(function(){

				buzz('success');

			}).always(function(x, t, m){

					if ( x.status === 403 ) {
						buzz('fail');
					} else if ( x.status === 401 ) {
						buzz('wait');
					}

			});

			e.preventDefault(); //STOP default action
		});


		bindBuzzer();

		// Controls

		$('.controls').on('click', '.reset', function(e){
			var $this = $(this);

			$.ajax({
				url : '/reset',
				type: "GET"
			});

			$this.addClass('active');

			setTimeout(function(){
				$this.removeClass('active');
			},5000);

		}).on('click', '.start', function(e){

			$(this).html('pause game').removeClass('start').addClass('pause');

			$.ajax({
				url : '/start',
				type: "GET"
			});


		}).on('click', '.pause', function(e){

			$(this).html('start game').removeClass('pause').addClass('start');

			$.ajax({
				url : '/pause',
				type: "GET"
			});

		}).on('click', '.right', function(e){

			$.ajax({
				url : '/right',
				type: "GET"
			});

		}).on('click', '.wrong', function(e){
			$.ajax({
				url : '/wrong',
				type: "GET"
			});
		});

		$('#name, #team').on('change',function(){
			var queryName = $('input').val(),
				queryTeam = $('select').val(),
				queryString = '?name=' + queryName + '&team=' + queryTeam;

			appendLinks(queryString);

			if (history.pushState) {
				var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + queryString;
				window.history.pushState({path:newurl},'',newurl);
			}
		});

		if ( queryName !== false && queryTeam !== false ){
			var queryString = '?name=' + queryName + '&team=' + queryTeam;

			appendLinks(queryString);

		}

	});

}(jQuery));