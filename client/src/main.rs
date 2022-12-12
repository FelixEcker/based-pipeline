use std::error::Error;
use tokio::net::TcpStream;
use std::io;
use std::io::Write;
use tokio::io::{AsyncReadExt, AsyncWriteExt};


#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {

    // let socket = TcpSocket::new_v4()?;

    let mut stream = TcpStream::connect("127.0.0.1:1337").await?;
    println!("Success connecting to 127.0.0.1:1337");

    let mut b1 = [0; 10];
    let mut b2 = [0; 10];

    // Peek at the data
    let n = stream.peek(&mut b1).await?;

    // Read the data

    assert_eq!(n, stream.read(&mut b2[..n]).await?);
    assert_eq!(&b1[..n], &b2[..n]);
    stream.write_all(b"Hello World!").await?;
    Ok(())
}
