<submission-overview>
  <div id='submission-overview-{ submission.id }', class="submission overview">
    <div riot-tag="submission-reply" each="{replies}" reply="{this}"></div>
  </div>

  <script>
    this.submission = parent.submission || opts.submission
    this.replies    = this.submission.replies
  </script>
</submission-overview>
