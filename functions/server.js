require('dotenv').config();
const express = require('express');
const cors = require('cors');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const app = express();
app.use(cors());
app.use(express.json());

// Health check
app.get('/', (req, res) => res.json({ status: 'QuickerQ payment server running' }));

// Create PaymentIntent
// POST /api/payments/create-intent
// Body: { amount: number (in paise), currency: string }
app.post('/api/payments/create-intent', async (req, res) => {
  try {
    const { amount, currency = 'inr' } = req.body;

    if (!amount || typeof amount !== 'number' || amount < 50) {
      return res.status(400).json({ error: 'Invalid amount. Must be a number >= 50 (paise).' });
    }

    const paymentIntent = await stripe.paymentIntents.create({
      amount,      // already in paise from Flutter
      currency,
      payment_method_types: ['card'],
    });

    res.status(201).json({ clientSecret: paymentIntent.client_secret });
  } catch (err) {
    console.error('Stripe error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 4242;
app.listen(PORT, () => console.log(`Payment server listening on http://localhost:${PORT}`));
