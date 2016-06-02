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
    this.submission = opts.submission
    this.headers = this.submission.headers.join("\n")

    this.on('mount', function(){
      $(".panel-heading", this.root).click(function(){
        // load the overview for this submission
      })
    })
  </script>
</submission-card>
