#!/bin/sh
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
PROJ="$(basename -- "${CWD}")"
EXT="xhtml"

cd "${CWD}"

if [ ! -d "${CWD}/.git" ]; then
  curl -fsSL "https://api.github.com/repos/ptb/autokeep/tarball/master" \
    | tar -C "${CWD}" --strip-components 1 -xz
  sh "${CWD}/initialize.command"
fi

cat > "${CWD}/.rubocop.yml" <<-EOF
Style/AlignParameters:
  EnforcedStyle: with_fixed_indentation

Metrics/LineLength:
  Max: 80
EOF

cat > "${CWD}/Gemfile" <<-EOF
ruby '2.3.3', patchlevel: '222'

source 'https://rubygems.org'
source "file:#{Dir.home}/.gem/cache"

gem 'builder', '~> 3.2'
gem 'bundler', '~> 1.13'
gem 'middleman', '~> 4.1'
gem 'middleman-blog', '~> 4.0'
gem 'middleman-minify-html', '~> 3.4'
gem 'nokogiri', '~> 1.6'
gem 'rubocop', '~> 0.46', require: false
gem 'slim', '~> 3.0'
gem 'slim_lint', '~> 0.8'
EOF

1> /dev/null bundle update

mkdir -p "${CWD}/.tmp" "${CWD}/data" "${CWD}/docs" "${CWD}/helpers" \
  "${CWD}/logs" "${CWD}/src/_example" "${CWD}/src/_layouts" \
  "${CWD}/src/_parts" "${CWD}/src/css" "${CWD}/src/fonts" "${CWD}/src/img" \
  "${CWD}/src/js" "${CWD}/src/js/example-tag.tag"

printf "%s\n" '*' '!.gitignore' > "${CWD}/.tmp/.gitignore"
touch "${CWD}/data/.keep" "${CWD}/docs/.keep" "${CWD}/src/.keep"

cat > "${CWD}/localhost.crt" <<-EOF
-----BEGIN CERTIFICATE-----
MIIEmjCCAoICAQEwDQYJKoZIhvcNAQELBQAwEjEQMA4GA1UEAxMHcHRiMi5tZTAe
Fw0xNjExMDExNjAwMDBaFw0xNzExMDExNjAwMDBaMBQxEjAQBgNVBAMTCWxvY2Fs
aG9zdDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKtTUxxo6ZJAUCIx
YehDOpxXr/UhsAMSV0jW1qegVjIWoVNOJi90cqbZlKuCVVUpzRhqHRcMmAB7g7fA
Jhzt8qt56T+atNHYV6sMuE4B3APF74lIFqQVfxO4duQWnIKea4jguYoWNXB9LzA4
XkIn104FYjrW71LbDm+7IW+IxaZ3sHh2s4NwGtCUZiKuxkt5JFIUx/Z4HVp0dSXI
1eH7h+b0e6XuE1L4BKkywDPGIxinZq55hgpA5h3I3YfofJs9l8RsJDOh1YkRJ+3g
pGp/RvnM8BwTOZrPV4Ut8b1loIWdMYpzvbgVjM27ayQX37nTwT+8MqQeFUGKdoUJ
TuXb2TaARU5YGfNLM5FQycArOTFuAjHgIOpWjzNKozMX73s2G6X2xUapNAaUfYg2
6UUVEML1+IciYI0/WEQSCgjDs9VYCNpO3DndY1GCAnzs9R/soA8aUNQTQOfuTrRS
0g/HzHXl1F8vldmQVP7qckymFpeTsPQB6sl9yNaUQ/BhrWiJ1gkulw+2fvz00z3D
0o8fGwlbkPRBn+7eqKg6tSfkkbX+pSu6JowDYB4GsOvbEZ0Hf+Sq+zkjRLVehnie
KWIddgzuU/CyFLdxHxzdsUotXuPc6VD1o6LNAH65LmpMNOruBLiZBI0Yj6j6brhR
nDwdJkZsJ8SxTBlWzcaHcaEp/jDVAgMBAAEwDQYJKoZIhvcNAQELBQADggIBAFUE
VbxYKLYPUGrWpx6ZUg3FbC5flGxt5VocAA6pIYDyhxDGVlbh5GS7dtUSw5aaZCtX
6IL/8sI5jGYEA0UiO97kExZ2RfJWw53plQAJM1V6tBAm278E2SwBi2XvIbTc5zNw
gGckRhPbgOtcR8Pgt02pvwJ66XGZn/Uwh3BSlG05mTubUYTEgFM6eU+Y8QLEm6+q
WRz1zfUVX0uQYcVAcUpj+WhXhSErgKvaYp5LHhpNXD8X9WsYODMWcEsgluo5SO/B
9+xR0PZMFzsGjbEbgIF61wtPqSdiWF+Ir9kPOoPbVcgyNbMHqAx2JNE/I7/ixJLw
Gt2Zxc1+GcZWSQcJiVCcJm80aLsCuQyK29n0JSnsBX8qwj7UQWzHHZvQGRHu8vev
VqMTyagmp7XHro+6CIjv7fCENQuxu8LG0V1ZdAVngowqMY/K4VG2Quwh1sHvAre4
59NFu9zP/qESdmU6yTN85gGXethtJaah9OG7V/smia1zSyfPBLk8QDPCPpBynDOC
oaqwf1iP8MH/WDZrJ329gDfnMagSnDUs34KwDICSc6lTX2hrLUguxWa62jFRSAK5
WJWjGd+TfzkxoqVTTXpfnBxWRMhhiMnbfgsuUt1MU2qsLBcdlfDEZSg3qG/fSon7
ARGGl/To+UnJ9SdV1dNtiJfemZ844gN/5c4Z26UR
-----END CERTIFICATE-----
EOF

cat > "${CWD}/localhost.key" <<-EOF
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
EOF

cat > "${CWD}/config.rb" <<-EOF
MIN = config[:environment] == :production
EXT = '${EXT}'.freeze

activate :blog do |blog|
  Time.zone = 'America/New_York'

  blog.sources = "{title}/index.#{EXT}"
  blog.default_extension = '.slim'

  # blog.layout = 'blog'
  blog.permalink = '{title}'

  # blog.generate_tag_pages = true
  blog.tag_template = "articles.#{EXT}"
  blog.taglink = "{tag}/index.#{EXT}"

  blog.calendar_template = "articles.#{EXT}"
  blog.year_link = "{year}/index.#{EXT}"
  blog.month_link = "{year}/{month}/index.#{EXT}"
  blog.day_link = "{year}/{month}/{day}/index.#{EXT}"

  blog.generate_year_pages = false
  blog.generate_month_pages = false
  blog.generate_day_pages = false

  blog.paginate = true
  blog.per_page = 3
  blog.page_link = 'page/{num}'
end

activate :directory_indexes

activate :external_pipeline,
  command: "node_modules/.bin/gulp build#{MIN ? ' --min' : nil} --silent",
  name: :gulp,
  source: '.tmp'

configure :development do
  if build?
    # url_for('/blog/file.xhtml') or url_for(sitemap.resources[0])
    # Example: link(href="#{url_for('/css/style.css')}" rel='stylesheet')

    activate :relative_assets
    set :relative_links, true
    set :strip_index_file, false
  end
end

configure :production do
  activate :asset_hash
  activate :minify_html, remove_quotes: false, simple_boolean_attributes: false
end

ignore(/.*\.keep/)
ignore(%r{\.tag/.*})

set :build_dir, 'docs' if File.directory? 'docs/'
set :css_dir, 'css' if File.directory? 'src/css/'
set :fonts_dir, 'fonts' if File.directory? 'src/fonts/'
set :images_dir, 'img' if File.directory? 'src/img/'
set :js_dir, 'js' if File.directory? 'src/js/'
set :layouts_dir, '_layouts' if File.directory? 'src/_layouts/'
set :source, 'src' if File.directory? 'src/'

set :https, true
set :ssl_certificate, 'localhost.crt'
set :ssl_private_key, 'localhost.key'

set :index_file, "index.#{EXT}"
set :layout, 'layout'

set :slim,
  attr_quote: "'",
  format: EXT.to_sym,
  pretty: !MIN,
  sort_attrs: true,
  shortcut: {
    '@' => { attr: 'role' },
    '#' => { attr: 'id' },
    '.' => { attr: 'class' },
    '%' => { attr: 'itemprop' },
    '^' => { attr: 'data-is' },
    '&' => { attr: 'type', tag: 'input' }
  }
EOF

cat > "${CWD}/helpers/custom_helpers.rb" <<-EOF
module CustomHelpers
  def article(article, content)
    partial '_parts/article', locals: {
      article: article,
      content: content,
      single: is_blog_article?
    }
  end

  def inline_tag(tag, *files)
    content_tag tag.to_sym do
      content = '/*<![CDATA[*/'
      files.map do |file|
        content << sitemap.find_resource_by_path(file).render
      end
      content << '/*]]>*/'
      content
    end
  end

  def page_intro
    if current_page.methods.include? :slug
      if File.exist?("src/_parts/_#{current_page.slug}.slim")
        partial "_parts/#{current_page.slug}"
      end
    elsif !!current_page.locals['tagname']
      if File.exist?("src/_parts/_#{current_page.locals['tagname']}.slim")
        partial "_parts/#{current_page.locals['tagname']}"
      end
    end
  end

  def page_title
    site_name = 'ptb2.me'
    if is_blog_article?
      "#{current_page.title} - #{site_name}"
    else
      d = Date.new(current_page.locals['year'] || 1, current_page.locals['month'] || 1, current_page.locals['day'] || 1)
      case current_page.locals['page_type']
      when 'day'
        "#{site_name} for #{d.strftime('%B')} #{d.strftime('%e').to_i.ordinalize}, #{d.strftime('%Y')}"
      when 'month'
        "#{site_name} for #{d.strftime('%B')} #{d.strftime('%Y')}"
      when 'year'
        "#{site_name} for #{d.strftime('%Y')}"
      when 'tag'
        "#{current_page.locals['tagname'].titleize} - #{site_name}"
      else
        "Welcome to #{site_name}"
      end
    end
  end

  def pagination
    if is_blog_article?
      partial '_parts/pagination', locals: {
        prev_pg: current_page.next_article,
        next_pg: current_page.previous_article,
        page_num: nil,
        total_pg: nil,
        single: true
      }
    else
      partial '_parts/pagination', locals: {
        prev_pg: current_page.locals['prev_page'],
        next_pg: current_page.locals['next_page'],
        page_num: current_page.locals['page_number'],
        total_pg: current_page.locals['num_pages'],
        single: false
      }
    end
  end
end
EOF

cat > "${CWD}/src/_layouts/layout.slim" <<-EOF
doctype 5
html.no-js(lang='en' xml:lang='en' xmlns='http://www.w3.org/1999/xhtml')
  head
    meta(charset='utf-8')/

    title = page_title

    meta(content='initial-scale=1, width=device-width' name='viewport')/

    link(href="#{url_for('/css/style.css')}" rel='stylesheet')/

    - if content_for? :head
      == yield_content :head

  body(itemscope itemtype='http://www.schema.org/Blog')

    #main@main(class="#{is_blog_article? ? nil : 'hfeed'}")
      == page_intro

      - if is_blog_article?
        == article(current_article, yield)
      - else
        - page_articles.each do |article|
          == article(article, article.summary)

      == pagination

    - if content_for? :foot
      == yield_content :foot

    - if server?
      script(src='/browser-sync/browser-sync-client.js')
EOF

touch "${CWD}/src/css/style.css.sass"

base64 -D > "${CWD}/src/favicon.ico" <<-EOF
  AAABAAEAEBACAAEAAQCwAAAAFgAAACgAAAAQAAAAIAAAAAEAAQAAAAAAAAAAAAAA
  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//wAA//8AAP//
  AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
  AAD//wAA
EOF

base64 -D > "${CWD}/src/apple-touch-icon-precomposed.png" <<-EOF
  iVBORw0KGgoAAAANSUhEUgAAALQAAAC0AQMAAAAHA5RxAAAAA1BMVEUmRcn0DMbc
  AAAAAXRSTlMAQObYZgAAABtJREFUeF7twAEJAAAAwjD7pzbHYVscAAAAwAEQ4AAB
  d61H3AAAAABJRU5ErkJggg==
EOF

cat > "${CWD}/src/index.${EXT}.slim" <<-EOF
---
pageable: true
per_page: 3
---
EOF

cd "${CWD}/src" && ln -s index.${EXT}.slim articles.${EXT}.slim && cd "${CWD}"

cat > "${CWD}/src/_parts/_article.slim" <<-EOF
article.hentry%blogPost<>(itemscope itemtype='http://schema.org/BlogPosting')
  header
    - unless article.tags.empty?
      ul.tags@navigation
        - article.tags.each do |tag, articles|
          li
            a%keywords(href="#{tag_path tag}" rel='tag') = tag

  h2.entry-title%headline
    - if single
      = article.title
    - else
      a.permalink%url(href="#{article.url}" rel='bookmark') = article.title

  - if single
    div.entry-content%articleBody
      == content
  - else
    div.entry-summary%description
      == content
EOF

cat > "${CWD}/src/_parts/_pagination.slim" <<-EOF
- if prev_pg || next_pg
  nav.pages@navigation(aria-labelledby='pagination')
    h3#pagination Page Navigation
    div
  - if prev_pg
    span.prev>
      a(href="#{prev_pg.url}" rel='prev')
        = single ? prev_pg.title : 'Newer'
  - if page_num && total_pg
    span.page
      = page_num
      span &#160;of&#160;
      = total_pg
  - if next_pg
    span.next<
      a(href="#{next_pg.url}" rel='next')
        = single ? next_pg.title : 'Older'
EOF

cat > "${CWD}/src/_example/index.${EXT}.slim" <<-EOF
---
title: Example
date: 2016-11-01
tags: examples
---
p
  |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
    veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
    commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id
    est laborum.

example-tag
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.slim" <<-EOF
p
  |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
    veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
    commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id
    est laborum.

div
  p
    |
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
      commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
      velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
      occaecat cupidatat non proident, sunt in culpa qui officia deserunt
      mollit anim id est laborum.
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.svg" <<-EOF
<svg xmlns="http://www.w3.org/2000/svg">
  <rect height="100" width="100" />
</svg>
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.sass" <<-EOF
\\:scope
  display: block

p
  width: 80em
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.es6" <<-EOF
/* eslint no-console: 0, no-magic-numbers: 0 */

/**
 * Add two numbers.
 * @param {number} a The first number.
 * @param {number} b The second number.
 * @returns {number} The sum of the two numbers.
 */
const add = (a, b) => a + b

console.log(add(4, 5))
EOF

cat > "${CWD}/package.json" <<-EOF
{
  "author": "Peter T Bosse II <ptb@ioutime.com> (http://ptb2.me)",
  "bugs": {
    "url": "https://github.com/ptb/${PROJ}/issues"
  },
  "dependencies": {},
  "description": "web project template",
  "devDependencies": {},
  "homepage": "https://github.com/ptb/${PROJ}#readme",
  "license": "Apache-2.0",
  "name": "${PROJ}",
  "repository": {
    "type": "git",
    "url": "git://github.com/ptb/${PROJ}.git"
  },
  "scripts": {},
  "version": "$(date '+%Y.%-m.%-e')"
}
EOF

1> /dev/null yarn add --dev \
  github:gulpjs/gulp#4.0 \
  gulp-cli \
  gulp-load-plugins \
  gulp-util \
  kexec

cat > "${CWD}/gulpfile.js" <<-EOF
// -- require ---------------------------------------------------------------

const gulp = require("gulp")
const plug = require("gulp-load-plugins")({
  "pattern": "*"
})
const proc = require("child_process")

// -- const -----------------------------------------------------------------

const MIN = typeof plug.util.env.min != "undefined"

// -- opts ------------------------------------------------------------------

const opts = new function () {
  return {
    "restart": {
      "files": ["config.rb", "Gemfile.lock", "gulpfile.js", "package.json",
        "yarn.lock"]
    }
  }
}()

// -- task ------------------------------------------------------------------

const task = {
  "restart": function () {
    if (process.platform === "darwin") {
      proc.spawn("osascript", ["-e", 'activate app "Terminal"', "-e",
        'tell app "System Events" to keystroke "k" using command down'])
    }
    plug.kexec("npm", ["run", MIN ? "build" : "start"])
  }
}

// -- gulp ------------------------------------------------------------------

gulp.task("build", function build (done) {
  done()
})

gulp.task("default", function watch (done) {
  gulp.watch(opts.restart.files, task.restart)
  done()
})
EOF

cat <<-EOF | patch 1> /dev/null
--- package.json
+++ package.json
@@ -22 +22,5 @@
-  "scripts": {},
+  "scripts": {
+    "prestart": "bundle install 1> /dev/null && yarn install 1> /dev/null",
+    "start": "gulp --silent",
+    "build": "gulp --min --silent"
+  },
EOF
