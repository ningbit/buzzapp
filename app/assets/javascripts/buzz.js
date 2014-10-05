(function($){

	$(document).ready(function(){

		var $body = $('body'),
			$buzzer = $('#buzzer'),
			$form = $('#form'),
			$controls = $('.controls'),
			timer = true,
			queryName = getQueryVariable('name'),
			queryTeam = getQueryVariable('team'),
			DELAY = 3000;

		navigator.vibrate = navigator.vibrate || navigator.webkitVibrate || navigator.mozVibrate || navigator.msVibrate,


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

		function ajaxGet(url){
			$.ajax({
				url : '/'+url,
				type: "GET"
			});
		}

		function playSound(action){

			var path = '/yoshi.wav',
				audio = new Audio(path);

			audio.play();

			if ( navigator.vibrate ) {

				navigator.vibrate(200);
			}
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
				playSound('success');

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

		$controls.on('click', '.reset', function(e){
			var $this = $(this);

			ajaxGet('reset');

			$this.addClass('active');

			setTimeout(function(){
				$this.removeClass('active');
			},5000);

		}).on('click', '.start', function(e){

			$controls.removeClass('game-paused');

			ajaxGet('start');

		}).on('click', '.pause', function(e){

			$controls.addClass('game-paused');

			ajaxGet('pause');

		}).on('click', '.right', function(e){

			if ( !$controls.hasClass('game-paused') ) {
				ajaxGet('right');
			}

		}).on('click', '.wrong', function(e){

			if ( !$controls.hasClass('game-paused') ) {
				ajaxGet('wrong');
			}
		}).on('click', '.scores', function(e){
			ajaxGet('scores');
		});

		$('#name').on('keydown',function(e){

			if(e.keyCode == 13){
				e.preventDefault();
				$('#team').focus();
			}
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

			if ( $(this).attr('id')==='team' ) {

				ajaxGet('welcome-team'+queryString);

			} else {

				ajaxGet('welcome-player'+queryString);
			}
		});

		if ( queryName !== false && queryTeam !== false ){
			var queryString = '?name=' + queryName + '&team=' + queryTeam;

			appendLinks(queryString);

		}

	});

}(jQuery));