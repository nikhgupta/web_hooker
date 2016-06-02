<submissions-box>
  <submissions-list submissions={submissions}></submissions-list>
  <submission-overview submission="{ submission }"></submission-overview>

  <style>

  </style>

  <script>
    this.submissions = opts.submissions
    this.submission  = this.submissions[0]
  </script>
</submissions-box>
