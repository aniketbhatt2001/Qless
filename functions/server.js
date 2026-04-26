require('dotenv').config();
const express = require('express');
const cors = require('cors');
const Razorpay = require('razorpay');

const app = express();
app.use(cors());
app.use(express.json());

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET,
});

// Health check
app.get('/', (req, res) => res.json({ status: 'QuickerQ payment server running' }));

// Create Razorpay Order
// POST /api/payments/create-order
// Body: { amount: number (in paise), currency: string }
app.post('/api/payments/create-order', async (req, res) => {
  try {
    const { amount, currency = 'INR' } = req.body;

    if (!amount || typeof amount !== 'number' || amount < 100) {
      return res.status(400).json({ error: 'Invalid amount. Must be a number >= 100 (paise).' });
    }

    const order = await razorpay.orders.create({
      amount,       // in paise
      currency,
      receipt: `receipt_${Date.now()}`,
    });

    res.status(201).json({ id: order.id, amount: order.amount, currency: order.currency });
  } catch (err) {
    console.error('Razorpay error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 4242;
app.listen(PORT, () => console.log(`Payment server listening on http://localhost:${PORT}`));
