FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV SECRET_KEY_BASE d23b0a44602f4cd5ee853bc43fb03b318970217c0cfdba138b535477df0184a5ed0f57d7be2fce915b149e4841bc2b78c3cd84b995e3d7d1cc7d86d4c092293e
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --without development test
COPY . /myapp
RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
