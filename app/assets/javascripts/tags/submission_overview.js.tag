<submission-overview>
  <div id='submission-overview-{ submission.id }', class="submission overview-bg-{ submission.status-style }">

    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
      <li role="presentation" class="active"><a href='#overview' role="tab" aria-controls="home" data-toggle="tab">Overview</a></li>
      <li role="presentation"><a href='#headers' role="tab" aria-controls="home" data-toggle="tab">Headers</a></li>
      <li role="presentation"><a href='#payload' role="tab" aria-controls="home" data-toggle="tab">Payload</a></li>
      <li role="presentation"><a href='#replies' role="tab" aria-controls="home" data-toggle="tab">Replies</a></li>
    </ul>

    <!-- Tab panes -->
    <div class="tab-content">
      <div role="tabpanel" class="tab-pane active" id="overview">
        <table class='key-value-table'>
          <tr><th>UUID</th><td>{  submission.uuid }</td></tr>
          <tr><th>Status</th><td>{  submission.status.to_s.titleize }</td></tr>
          <tr><th>Matched Rule</th><td>{  submission.portal_link }</td></tr>
          <tr><th>Request Method</th><td>{  submission.request_method }</td></tr>
          <tr><th>Content Type</th><td>{  submission.content_type }</td></tr>
          <tr><th>Accepts</th><td>{  submission.accept_type }</td></tr>
          <tr><th>Request Size</th><td>{  submission.size }</td></tr>
          <tr><th>Received at</th><td>{  submission.received_at }</td></tr>
        </table>
      </div>
      <div role="tabpanel" class="tab-pane" id="headers">
        <table class='key-value-table'>
          <tr each="{key, val in submission.headers }">
            <th>{key}</th><td>{val}</td>
          </tr>
        </table>
      </div>
      <div role="tabpanel" class="tab-pane" id="payload">
        <pre if="{ headers.length > 0}"><code>{ headers }</code></pre>
        <br/><br/>
        <code>{ submission.body }</code>
      </div>
      <div role="tabpanel" class="tab-pane" id="replies">
        <div riot-tag="submission-reply" each="{replies}" reply="{this}"></div>
      </div>
    </div>
  </div>

  <script>
    this.submission = parent.submission || opts.submission
    this.replies    = this.submission.replies
    this.headers    = this.submission.headers_list.join("\n")
  </script>
</submission-overview>
