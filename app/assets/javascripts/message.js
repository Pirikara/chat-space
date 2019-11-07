$(document).on('turbolinks:load',function(){
  $(function(){
    function buildHTML(message){
      let image = message.image? `<img class='message_image' src=${message.image} >` : "";
      let html = `<div class='message'>
                    <div class='message__upper-info'>
                      <div class='message__upper-info__name'>
                        ${message.user_name}
                      </div>
                      <div class='message__upper-info__date'>
                        ${message.date}
                      </div>
                    </div>
                    <div class='message__text'>
                      <p class='message__text__content'>
                      ${content}
                      </p>
                    </div>
                    ${image}
                  </div>`
      return html;
    }
    $('#new_message').on('submit',function(e){
      e.preventDefault();
      var formData = new FormData(this);
      var url = $(this).attr('action');
      $.ajax({
        url: url,
        type: 'POST',
        data: formData,
        dataType: 'json',
        processData: false,
        contentType: false
      })
      .done(function(data){
        let html = buildHTML(data);
        $('.messages').append(html);
        $('.new_message')[0].reset();
        $('.messages').animate({ scrollTop: $('.messages')[0].scrollHeight });
      })
      .fail(function(){
        alert('メッセージの送信に失敗しました。');
      })
      .always(function(data){
        $('.submit-btn').prop('disabled', false);
      })
    });
  });
});