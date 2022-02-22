import "../styles/globals.css";
import Link from "next/link";
function MyApp({ Component, pageProps }) {
  return (
    <div>
      <nav className="border-b p-6">
        <div className="flex mt-4">
          <p className="text mr-6 font-bold">NFT Marketplace</p>
          <Link href="/">
            <a className="mr-6 text-blue-500">Home</a>
          </Link>
          <Link href="/create-item">
            <a className="mr-6 text-blue-500">Sell Digital Asset</a>
          </Link>{" "}
          <Link href="/my-assets">
            <a className="mr-6 text-blue-500">My Digital Assets</a>
          </Link>
          <Link href="/creator-dashboard">
            <a className="mr-6 text-blue-500">Creator Dashboard</a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  );
}

export default MyApp;
