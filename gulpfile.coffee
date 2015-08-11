gulp = require "gulp"

merge = require "gulp-merge"
coffee = require "gulp-coffee"
concat = require "gulp-concat"

gulp.task "client-js", () ->
    merge(
        gulp.src([
            "./bower_components/angular/angular.js"
        ])
    ,
        gulp.src([
            "./assets/coffee/*.coffee"
        ])
            .pipe coffee({bare:true})
    )
        .pipe concat "client.js"
        .pipe gulp.dest "./static/build"
