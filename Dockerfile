FROM ruby:3.4.13-alpine

# build-base: native gem extensions (sassc, ffi, eventmachine)
# nodejs: JavaScript runtime for execjs/uglifier (jekyll-minifier)
RUN apk add --no-cache build-base nodejs

WORKDIR /srv/jekyll

COPY Gemfile Gemfile.lock ./
RUN bundle install

EXPOSE 3000 35729

CMD ["bundle", "exec", "jekyll", "serve", "-H", "0.0.0.0", "-P", "3000"]
