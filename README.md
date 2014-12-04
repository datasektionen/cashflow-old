# Cashflow

## Setup for local development

1. Install the correct version of Ruby, preferably using a Ruby version manager
like RVM or rbenv.

    rvm install $(cat .ruby-version)

or

    rbenv install $(cat .ruby-version)

2. Install additional dependencies.

    sudo apt-get install mysql-server libmysqlclient-dev

3. Run `script/bootstrap`. If you are prompted for a database password: kill the
script with C-c, update `config/database.yml` with your database credentials and
try again.

## Running the server

1. Start SOLR

    bundle exec sunspot:solr:start

2. Set up a tunnel for LDAP

    ssh -L 9999:ldap.kth.se:389 KTHID@my.nada.kth.se

3. Start the Rails server

    bundle exec rails server

replacing KTHID with your KTH username, like `koronen`.

## Running the tests

Insert your ugid into config/local.yml in order to get the controller specs to
work properly (otherwise the test code can't log in).
