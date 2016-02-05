'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');

gulp.task('sass', function () {
  gulp.src('./scss/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'));
  gulp.src('./game/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./game'));
});

gulp.task('coffee', function() {
  gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./'));
});

gulp.task('watch', function() {
  gulp.start('sass', 'coffee')
  gulp.watch('./scss/**/*.scss', ['sass']);
  gulp.watch('./game/**/*.scss', ['sass']);
  gulp.watch('./src/*.coffee', ['coffee']);
});

gulp.task('default', function() {
  gulp.start('sass', 'coffee');
});
