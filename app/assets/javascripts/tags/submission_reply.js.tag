<submission-reply>
  <pre if="{ headers.length < 1}"><code>{ reply.body }</code></pre>
  <pre if="{ headers.length > 0}"><code>{ headers }</code><br/><br/><code>{ reply.body }</code></pre>

  <div class="panel panel-{ reply.status_style } reply card" data-id="{ reply.id }">

    <div class="panel-heading" data-toggle="collapse"
      data-parent="submission-overview-{ reply.submission.id }"
      data-target=".reply.card[data-id='{ reply.id }'] .panel-body">
      { reply.destination_url }
    </div>

    <div class="panel-body collapse out">
      <raw content="{ reply.full_body }"></raw>
    </div>

    <div class="panel-footer" data-toggle="collapse"
      data-parent="#submission-overview-{ reply.submission.id }"
      data-target=".reply.card[data-id='{ reply.id }'] .panel-body">

      Received {  reply.content_length } in {  reply.response_time }ms
      <span class="label pull-right label-default">{ reply.http_status_code } { reply.http_status_message }</span>
      <span class="label pull-right" style='color: #777'>{ reply.content_type }</span>
      <span class="label pull-right label-warning" if="{ reply.body.length < 1 }">Body missing</span>
      <span class="label pull-right label-danger" if="{ headers.length < 1 }">Headers missing</span>
    </div>

  </div>
  <script>
    this.reply   = parent.reply || opts.reply
    console.log(this.reply)
    this.headers = this.reply.headers_list.join("\n")
    this.full_body = this.reply.headers_with_body.join("<br/>")
  </script>
</submission-reply>
