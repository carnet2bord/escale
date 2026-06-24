/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // @react-pdf/renderer doit rester côté serveur (rendu PDF en Node).
  serverExternalPackages: ['@react-pdf/renderer'],
};

export default nextConfig;
