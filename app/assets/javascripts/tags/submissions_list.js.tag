<submissions-list>
  <div riot-tag="submission-card" each={submission in submissions} submission="{submission}"></div>
  <div class='load-more' if="{!pagination.last_page}"><span>Load More</span></div>

  <style type='text/scss'>
    div.load-more {
      width: 100%;
      padding: 10px;
      background-color: #efefef;
      margin-bottom: 60px;
      text-align: center;
      cursor: pointer;
    }
  </style>

  <script>
    app = this;
    this.submissions = opts.submissions || parent.submissions
    this.pagination  = { last_page: opts.last_page, next_page: 2, first_page: true }

    this.on("mount", function() {
      $("div.load-more", this.root).on("click", function(){
        $.get("/submissions.json", { page: app.pagination.next_page }, function(response, _, xhr){
          $.merge(app.submissions, response)
          app.pagination = $.parseJSON(xhr.getResponseHeader("X-Pagination"))
          app.parent.update()
        })
      })
    })
  </script>
</submissions-list>
