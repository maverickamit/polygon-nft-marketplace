import Head from "next/head";
import styles from "../styles/Home.module.css";

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>NFT Market Place</title>
      </Head>
      <h1>Welcome to NFT Market Place!</h1>
    </div>
  );
}
