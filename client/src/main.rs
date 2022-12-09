use core::time;
use std::error::Error;
use tokio::net::TcpStream;
use std::io;
use std::io::Write;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use std::str;

// timing
use std::time::{Duration, SystemTime};
use std::thread;

// audio playback
use std::fs::File;
use std::io::BufReader;
use rodio::{Decoder, OutputStream, source::Source};


#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {

    // let socket = TcpSocket::new_v4()?;

    // prepare Sound stream
    let (_stream, stream_handle) = OutputStream::try_default().unwrap();
    let file = BufReader::new(File::open("based.mp3").unwrap());
    let source = Decoder::new(file).unwrap();
    

    let mut stream = TcpStream::connect("127.0.0.1:5001").await?;
    println!("Success connecting to 127.0.0.1:5001");

    let mut b1 = [0; 13];
    let mut b2 = [0; 13];

    // Peek at the data
    let n = stream.peek(&mut b1).await?;

    // Read the data

    assert_eq!(n, stream.read(&mut b2[..n]).await?);
    assert_eq!(&b1[..n], &b2[..n]);
    println!("{:?}", b2);

    let timestamp = str::from_utf8(&b2)?;           // get string representation of ascii codes
    let timestamp: u64 = timestamp.parse().unwrap();      // parse string to long    
    
    let mut now = SystemTime::now().duration_since(SystemTime::UNIX_EPOCH).unwrap().as_millis() as u64;    // get local unix timestamp as millis kekw this could panic in 2077 or so
    let sleepTimer = time::Duration::from_millis(timestamp - now);
    
    println!("Sound deadline from remote⏰: {}", timestamp);
    println!("Current time⌚️: {}", now);
 
    thread::sleep(sleepTimer);  // yes this is bad oops

    now = SystemTime::now().duration_since(SystemTime::UNIX_EPOCH).unwrap().as_millis() as u64;
    println!("now its⌚️: {}!", now);

    stream_handle.play_raw(source.convert_samples())?;  // play basedness sound
    thread::sleep(time::Duration::from_secs(5));        // sleep for 5 secs TODO get file track duration

    //stream.write_all(b"Hello World!").await?;
    Ok(())
}