const app = require('./app');
const config = require('./config');

app.listen(config.port, () => {
  console.log(`Health2U admin-service listening on http://localhost:${config.port}`);
});
