const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const vendorRoutes = require('./routes/vendorRoutes');
const orderRoutes = require('./routes/orderRoutes');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use('/api/vendor', vendorRoutes);
app.use('/api/orders', orderRoutes);

app.get('/api/ping', (req, res) => res.json({ status: 'ok' }));

// Serve client build statically when in production
const path = require('path')
if (process.env.NODE_ENV === 'production') {
  const clientDist = path.join(__dirname, '..', '..', 'client', 'dist')
  app.use(express.static(clientDist))
  app.get('*', (req, res) => res.sendFile(path.join(clientDist, 'index.html')))
}

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Vendor-dashboard API listening on port ${PORT}`));