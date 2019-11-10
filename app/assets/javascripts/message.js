$(function(){
  function buildHTML(message){

    image = message.image ? `<img class='message_image' src=${message.image} >` : "";
    let html = `<div class='message' data-message-id="${message.id}">
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
                    ${message.content}
                    </p>
                  </div>
                  ${image}
                </div>`
    return html;
  }

  var reloadMessages = function() {
    if (window.location.href.match(/\/groups\/\d+\/messages/)){
      var last_message_id = $('.message:last').data("message-id");
      var href = 'api/messages#index {:format=>"json"}'
      $.ajax({
        url: href,
        type: 'GET',
        data: {id: last_message_id},
        dataType: 'json'
      })
      .done(function (messages) {
        var insertHTML = '';
        messages.forEach(function (message) {
          insertHTML = buildHTML(message);
          $('.messages').append(insertHTML);
          $('.messages').animate({ scrollTop: $('.messages')[0].scrollHeight }, 'fast');
        })
      })
      .fail(function () {
        alert("自動更新に失敗しました");
      });
    }
  };

  setInterval(reloadMessages, 5000);

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
      $('.messages').animate({ scrollTop: $('.messages')[0].scrollHeight }, 'fast');
    })
    .fail(function(){
      alert('メッセージの送信に失敗しました。');
    })
    .always(function(data){
      $('.submit-btn').prop('disabled', false);
    });
  });
});