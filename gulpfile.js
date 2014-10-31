"use strict"

// -- DEPENDENCIES -------------------------------------------------------------
var gulp    = require('gulp');
var coffee  = require('gulp-coffee');
var concat  = require('gulp-concat');
var connect = require('gulp-connect');
var flatten = require('gulp-flatten');
var header  = require('gulp-header');
var uglify  = require('gulp-uglify');
var gutil   = require('gulp-util');
var stylus  = require('gulp-stylus');
var yml     = require('gulp-yml');
var pkg     = require('./package.json');

// -- FILES --------------------------------------------------------------------
var assets = 'www/assets/';
var source = {
  coffee: [ 'source/zen.coffee',
            'source/zen.*.coffee'],
  styl  : [ 'source/styles/__init.styl',
            'source/styles/vendor.styl',
            'source/styles/reset.styl',
            'source/styles/app.styl',
            'source/styles/app.*.styl']};

var dependencies = {
    js   :[ 'bower_components/jquery/dist/jquery.min.js',
            'bower_components/hope/hope.js',
            'bower_components/moment/min/moment.min.js',
            'bower_components/highcharts/highcharts.js',
            // 'bower_components/highcharts/modules/canvas-tools.js',
            // 'bower_components/highcharts/modules/data.js',
            // 'bower_components/highcharts/modules/drilldown.js',
            'bower_components/highcharts/modules/exporting.js',
            // 'bower_components/highcharts/modules/funnel.js',
            // 'bower_components/highcharts/modules/heatmap.js',
            // 'bower_components/highcharts/modules/no-data-to-display.js',
            // 'bower_components/highcharts/modules/solid-gauge.js',
            'bower_components/highcharts/themes/dark-unica.js',
            'bower_components/ua-parser-js/src/ua-parser.js'
          ],
    css  :[ 'bower_components/tuktuk/tuktuk.grid.css']};

var banner = ['/**',
  ' * <%= pkg.name %> - <%= pkg.description %>',
  ' * @version v<%= pkg.version %>',
  ' * @link    <%= pkg.homepage %>',
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)',
  ' * @license <%= pkg.license %>',
  ' */',
  ''].join('\n');

// -- TASKS --------------------------------------------------------------------
gulp.task('dependencies', function() {
  gulp.src(dependencies.js)
    .pipe(concat(pkg.name + '.dependencies.js'))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/js'));

  gulp.src(dependencies.css)
    .pipe(concat(pkg.name + '.dependencies.css'))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/css'));
});

gulp.task('coffee', function() {
  gulp.src(source.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/js'))
    .pipe(connect.reload());
});

gulp.task('styl', function() {
  gulp.src(source.styl)
    .pipe(concat(pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/css'))
    .pipe(connect.reload());
});

gulp.task('webserver', function() {
  connect.server({ port: 8000, root: 'www/', livereload: true });
});

gulp.task('init', function() {
  gulp.run(['dependencies', 'coffee', 'styl'])
});

gulp.task('default', function() {
  gulp.run(['webserver'])
  gulp.watch(dependencies.js, ['dependencies']);
  gulp.watch(source.coffee, ['coffee']);
  gulp.watch(source.styl, ['styl']);
});
