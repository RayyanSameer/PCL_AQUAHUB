const express = require('express');
const router = express.Router();
const orderService = require('../../services/orderService');

router.get('/pending', async (req, res) => {
  try {
    const orders = await orderService.getPendingOrders();
    res.json({ orders });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.get('/vendor/:vendorId', async (req, res) => {
  try {
    const vendorId = parseInt(req.params.vendorId, 10);
    const orders = await orderService.getVendorOrders(vendorId);
    res.json({ orders });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.post('/:orderId/accept', async (req, res) => {
  try {
    const orderId = parseInt(req.params.orderId, 10);
    const { vendorId } = req.body;
    const updated = await orderService.acceptOrder(orderId, vendorId);
    res.json({ updated });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.post('/:orderId/decline', async (req, res) => {
  try {
    const orderId = parseInt(req.params.orderId, 10);
    const dec = await orderService.declineOrder(orderId);
    res.json({ declined: dec });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.post('/:orderId/complete', async (req, res) => {
  try {
    const orderId = parseInt(req.params.orderId, 10);
    const { vendorId } = req.body;
    const comp = await orderService.completeDelivery(orderId, vendorId);
    res.json({ completed: comp });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

router.get('/:orderId', async (req, res) => {
  try {
    const order = await orderService.getOrderById(parseInt(req.params.orderId, 10));
    if (!order) return res.status(404).json({ error: 'Not found' });
    res.json({ order });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal error' });
  }
});

module.exports = router;