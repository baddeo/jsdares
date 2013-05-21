process.env.JSDARES_ENV = process.env.JSDARES_ENV or 'development'
process.env.JSDARES_MONGO_DB_PATH = process.env.JSDARES_MONGO_DB_PATH or 'localhost:27017/jsdares'
process.env.JSDARES_EMAIL = process.env.JSDARES_EMAIL or 'test@test.com'
process.env.JSDARES_EMAIL_NAME = process.env.JSDARES_EMAIL_NAME or 'jsdares'
process.env.JSDARES_COOKIE_SECRET = process.env.JSDARES_COOKIE_SECRET or 'somesecret'

# process.env.JSDARES_GMAIL_USER
# process.env.JSDARES_GMAIL_PASS
debug_enabled = (process.env.JSDARES_ENV is 'development')
options =
  mongodb: 'mongodb://' + process.env.JSDARES_MONGO_DB_PATH + '?auto_reconnect'
  assets: __dirname + '/assets'
  
  # browserify:
  # 	entry: __dirname + '/client-entry.js',
  # 	debug: debug_enabled,
  # 	cache: !debug_enabled
  logs:
    requests: debug_enabled

  api:
    cookieSecret: process.env.JSDARES_COOKIE_SECRET
    errors:
      400: true
      401: true
      404: true
      500: true

  mailer:
    transport:
      type: 'SMTP'
      options:
        service: 'Gmail'
        auth:
          user: process.env.JSDARES_GMAIL_USER
          pass: process.env.JSDARES_GMAIL_PASS

    from:
      name: 'jsdares'
      email: process.env.JSDARES_EMAIL

    log: debug_enabled

connect = require('connect')
app = connect()
app.use require('grunt-contrib-livereload/lib/utils').livereloadSnippet
app.use require('./server').middleware(connect, options)

module.exports = app