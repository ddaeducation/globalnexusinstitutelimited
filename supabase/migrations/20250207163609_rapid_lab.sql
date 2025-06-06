-- Applications table
CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  program_id uuid REFERENCES programs,
  education_level text NOT NULL,
  work_experience text,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- Allow public to submit applications
CREATE POLICY "Anyone can submit applications"
  ON applications
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Only admins can view applications
CREATE POLICY "Only admins can view applications"
  ON applications
  FOR SELECT
  TO authenticated
  USING (auth.jwt() ->> 'email' IN (SELECT email FROM auth.users WHERE is_admin = true));

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Allow public to subscribe
CREATE POLICY "Anyone can subscribe"
  ON subscriptions
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Only admins can view subscriptions
CREATE POLICY "Only admins can view subscriptions"
  ON subscriptions
  FOR SELECT
  TO authenticated
  USING (auth.jwt() ->> 'email' IN (SELECT email FROM auth.users WHERE is_admin = true));