<submission-card>
  <div class="panel panel-{ submission.type } submission card" data-id="{ submission.id }">
    <div class="panel-heading">
      <div class='submission-info'>
        <span class="label label-info">{ submission.portal.title }</span>
        <span class='label label-warning'>{ submission.host || submission.ip }</span>
        <span each={submission.replies} class="ping-ball {this.status}"></span>
        <span class="timestamp" data-timestamp="{submission.timestamp}">{ submission.timestamp_in_words }</span>
      </div>
      <div class='submission-details'>
        <code>{ submission.uuid }</code>
      </div>
    </div>
    <div class="panel-body">
      <code>{ headers }</code>
    </div>
  </div>

  <script>
    app = this
    this.submission = opts.submission
    this.headers = this.submission.headers_list.join("\n")

    this.on('mount', function(){
      $(".panel-heading", this.root).click(function(){
        requested = $(this).parent().data('id')
        overview  = app.parent.parent.tags["submission-overview"]
        if (overview.submission.id == requested) return

        $.get("/submissions/"+requested+".json", function(response){
          overview.update({ submission: response })
        })
      })
    })
  </script>
</submission-card>
