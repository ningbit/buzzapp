(function($){

	$(document).ready(function(){

		var $body = $('body'),
			$createQuestion = $('#create-question'),
			$create = $('#create'),
			$questions = $('.questions'),
			$quiz = $('.quiz'),
			DELAY = 3000;

		function getAjax($topic){
			$.ajax({
				url : '/topics/'+$topic.data('id')+'/questions',
				type: "GET",

			}).done(function(data){
				$questions.removeClass('_inactive');
				$quiz.find('ul').remove();
				$('.btn-back').hide();
				var url = $quiz.append(data).find('li._active').data('url');
				speakUrl(url);

			}).fail(function(x,t,m){

			}).always(function(x, t, m){

					if ( x.status === 403 ) {
					} else if ( x.status === 401 ) {
					}

			});
		}

		function speakUrl(url){
			$.ajax({
				url: url,
				type: "GET",
			});
		}

		$('.btn-topic').not('.btn-add').not('.inactive').on('click', function(){
			var $topicBtn = $(this);

			$('.btn-topic._active').removeClass('_active');
			$topicBtn.toggleClass('_active');

			getAjax($topicBtn);

		});

		function submitComplete(){
			$createQuestion.find('input[type=text]').val('');
			$create.html('success').addClass('success');

			setTimeout(function(){
				$create.removeClass('success').html('create');
			}, 2000)
		}

		function submitFail(){
			$create.html('failed').addClass('fail');

			setTimeout(function(){
				$create.removeClass('fail').html('create');
			}, 2000)
		}

		$questions
			.on('click', '.btn-next', function(){
				var $activeQ = $('li._active');

				console.log($quiz.find('.question').length);

				if ( $activeQ.index() == $quiz.find('.question').length-2 ) {
					$(this).hide();
				} else {
					$('.btn-back').show();
				}

				var qUrl = $activeQ.removeClass('_active').next('li').addClass('_active').data('url');

				speakUrl(qUrl);

			})
			.on('click','.btn-back', function(){
				var $activeQ = $('li._active');

				if ( $activeQ.index() == 1 ) {
					$(this).hide();
				} else {
					$('.btn-next').show();
				}

				$('li._active').removeClass('_active').prev('li').addClass('_active');
			})
			.on('click','.btn-answer',function(){

				var $activeQ = $('li._active');

				$activeQ.find('.answer').show();
				$(this).hide();

			});

		$('#create-question').find('input[type=text]').on('keydown',function(e){

			if(e.keyCode == 13){
				e.preventDefault();
			}
		});

		$createQuestion.submit(function(e) {

			var postData = $(this).serializeArray();
			var formURL = $(this).attr("action");
			$.ajax({
				url : formURL,
				type: "POST",
				data : postData,

			}).done(function(data){

				console.log(data);
				submitComplete();

			}).fail(function(x, t, m){

				submitFail();

			});

			e.preventDefault(); //STOP default action
		});

		function bindCreate() {
			$create.on('click', function(e){

				e.preventDefault();

				$createQuestion.submit();

			});
		}

		bindCreate();

	});

}(jQuery));