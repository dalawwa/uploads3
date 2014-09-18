# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#fileupload').fileupload
    add: (e, data) ->
      types = /(\.|\/)(dxf)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $($.parseHTML(tmpl("template-upload", file))[1])
        $('#fileupload').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a valid DXF file")
    
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
    
    done: (e, data) ->
      file = data.files[0]
      domain = $('#fileupload').attr('action')
      path = $('#fileupload input[name=key]').val().replace('${filename}', file.name)
      to = $('#fileupload').data('post')
      content = {}
      content[$('#fileupload').data('as')] = domain + path
      $.post(to, content)
      data.context.remove() if data.context # remove progress bar
    
    fail: (e, data) ->
      alert("#{data.files[0].name} failed to upload.")
      console.log("Upload failed:")
      console.log(data)
