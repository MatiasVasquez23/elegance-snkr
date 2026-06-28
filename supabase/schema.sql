-- ============================================================
-- Elegance Snkr — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- Products
CREATE TABLE IF NOT EXISTS products (
  id              BIGSERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  brand           TEXT NOT NULL DEFAULT 'Nike',
  colorway        TEXT DEFAULT '',
  price           INTEGER NOT NULL,
  original_price  INTEGER DEFAULT 0,
  stock           INTEGER DEFAULT 0,
  emoji           TEXT DEFAULT '👟',
  badge           TEXT DEFAULT '',
  sizes           TEXT[] DEFAULT '{}',
  description     TEXT DEFAULT '',
  active          BOOLEAN DEFAULT true,
  featured        BOOLEAN DEFAULT false,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Newsletter subscribers
CREATE TABLE IF NOT EXISTS subscribers (
  id         BIGSERIAL PRIMARY KEY,
  email      TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Orders (for WhatsApp-based orders tracking)
CREATE TABLE IF NOT EXISTS orders (
  id             BIGSERIAL PRIMARY KEY,
  customer_email TEXT,
  customer_name  TEXT,
  items          JSONB NOT NULL DEFAULT '[]',
  total          INTEGER NOT NULL DEFAULT 0,
  status         TEXT DEFAULT 'pending',
  notes          TEXT DEFAULT '',
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- Row Level Security
-- ============================================================

ALTER TABLE products    ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders      ENABLE ROW LEVEL SECURITY;

-- Anyone can read active products
CREATE POLICY "products_read_all"
  ON products FOR SELECT USING (active = true);

-- Authenticated users (admin) can manage products
CREATE POLICY "products_manage_auth"
  ON products FOR ALL
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- Anyone can subscribe
CREATE POLICY "subscribers_insert_all"
  ON subscribers FOR INSERT WITH CHECK (true);

-- Authenticated users can read subscribers
CREATE POLICY "subscribers_read_auth"
  ON subscribers FOR SELECT
  USING (auth.role() = 'authenticated');

-- Anyone can create an order
CREATE POLICY "orders_insert_all"
  ON orders FOR INSERT WITH CHECK (true);

-- Authenticated users can manage orders
CREATE POLICY "orders_manage_auth"
  ON orders FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================
-- Seed Data
-- ============================================================

INSERT INTO products (name, brand, colorway, price, original_price, stock, emoji, badge, sizes, description) VALUES
  ('Air Jordan 1 Retro High OG', 'Jordan', 'Chicago / Red',  185000, 210000, 3, '🔴', 'exclusive', ARRAY['7','7.5','8','8.5','9','10'],         'El ícono absoluto del sneaker game. Colorway Chicago original, certificado con caja y factura.'),
  ('Nike Air Max 1 SC',          'Nike',   'Varsity Red',      95000,      0, 5, '💙', 'new',       ARRAY['7','8','8.5','9','9.5','10','11'],       'La Air Max que inició todo. Amortiguación visible, estética clásica y comodidad suprema.'),
  ('Adidas Yeezy Boost 350 V2',  'Adidas', 'Zebra',           220000,      0, 2, '⚡', 'limited',   ARRAY['7.5','8','8.5','9','10'],               'Diseño de Kanye West. PRIMEKNIT + Boost. El par más icónico del streetwear moderno.'),
  ('New Balance 550',            'New Balance', 'White/Green',  75000,  90000, 8, '🟢', 'sale',      ARRAY['7','7.5','8','8.5','9','9.5','10','11'], 'El retro basketball más popular de la temporada. Cuero premium con suela vulcanizada.'),
  ('Nike Dunk Low Retro',        'Nike',   'Panda White/Black', 88000,     0, 4, '🖤', 'hot',       ARRAY['7','7.5','8','9','10','10.5'],           'El modelo más buscado. Combinación clásica blanco/negro con cuero premium.'),
  ('Air Jordan 4 Retro',         'Jordan', 'Military Black',  165000,      0, 2, '🏀', 'limited',   ARRAY['8','8.5','9','10'],                     'El AJ4 Military Black. Diseño icónico de 1989 con actualización moderna.'),
  ('Adidas Ultraboost 22',       'Adidas', 'Core Black',       68000,  85000, 6, '🌿', 'sale',      ARRAY['7','7.5','8','8.5','9','9.5','10','11','12'], 'La zapatilla de running premium. Tecnología Boost para máxima amortiguación.'),
  ('New Balance 990v5',          'New Balance', 'Made in USA · Grey', 145000, 0, 3, '🇺🇸', 'exclusive', ARRAY['7.5','8','8.5','9','9.5','10'], 'Fabricada en USA. Calidad artesanal y comfort técnico inigualable.')
ON CONFLICT DO NOTHING;
