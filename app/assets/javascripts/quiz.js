(function($){

	$(document).ready(function(){

		var $body = $('body'),
			$form = $('#form'),
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
				$quiz.append(data);

			}).fail(function(x,t,m){

			}).always(function(x, t, m){

					if ( x.status === 403 ) {
					} else if ( x.status === 401 ) {
					}

			});
		}

		$('.btn-topic').not('.btn-add').on('click', function(){
			var $topicBtn = $(this);

			$('.btn-topic._active').removeClass('_active');
			$topicBtn.toggleClass('_active');

			getAjax($topicBtn);

		});

		$questions
			.on('click', '.btn-next', function(){
				var $activeQ = $('li._active');

				if ( $activeQ.index() == $('li').length-2 ) {
					$(this).hide();
				} else {
					$('.btn-back').show();
				}

				$activeQ.removeClass('_active').next('li').addClass('_active');

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

	});

}(jQuery));