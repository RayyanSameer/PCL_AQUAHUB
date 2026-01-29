const express = require('express');
const router = express.Router();
const vendorService = require('../../services/vendorService');

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const vendor = await vendorService.login(email, password);
    if (!vendor) return res.status(401).json({ error: 'Invalid credentials' });
    res.json({ vendor });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.get('/:vendorId/earnings', async (req, res) => {
  try {
    const vendorId = parseInt(req.params.vendorId, 10);
    const data = await vendorService.getEarnings(vendorId);
    res.json(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.get('/:vendorId', async (req, res) => {
  try {
    const vendor = await vendorService.getVendorById(parseInt(req.params.vendorId, 10));
    if (!vendor) return res.status(404).json({ error: 'Not found' });
    res.json(vendor);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

module.exports = router;