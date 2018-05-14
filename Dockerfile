FROM ruby:2.5.0
ENV APP_HOME /production
RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
RUN mkdir $APP_HOME
WORKDIR $APP_HOME    /var/lib/log
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME
CMD bundle exec rails s -p ${PORT} -b '0.0.0.0'
