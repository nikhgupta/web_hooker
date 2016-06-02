<submission-reply>
  <pre if="{ headers.length < 1}"><code>{ reply.body }</code></pre>
  <pre if="{ headers.length > 0}"><code>{ headers }</code><br/><br/><code>{ reply.body }</code></pre>

<script>
  this.reply   = parent.reply || opts.reply
  console.log(this.reply)
  this.headers = this.reply.headers.join("\n")
</script>
</submission-reply>
