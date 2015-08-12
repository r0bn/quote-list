gulp = require "gulp"

merge = require "gulp-merge"
coffee = require "gulp-coffee"
concat = require "gulp-concat"

server = require "gulp-develop-server"
browserSync = require "browser-sync"

reload = browserSync.reload

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
        .pipe reload({stream:true})

gulp.task "watch", ["build"], () ->
    gulp.watch ["assets/coffee/**/*"], ["client-js"]
    gulp.watch ["app.coffee", "server/**/*"], ["server:restart"]

gulp.task "build", ["client-js"], () ->

gulp.task "default", ["browser-sync", "server"]

gulp.task "server", () ->
    server.listen {path:"app.coffee"}


gulp.task "browser-sync", ["watch"], () ->
    browserSync {
        proxy:"localhost:3000"
        open:"false"
        port:"3001"
    }

gulp.task "server:restart", () ->
    server.restart (error) ->
        if !error
            reload()
