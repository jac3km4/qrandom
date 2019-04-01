# qrandom
This project defines a `QRandom` free monad for random generation of sequences of 8 and 16-bit unsigned integers and hex strings.


It also implements an interpreter that uses The ANU Quantum Random Number Generator (qrng.anu.edu.au), which can be used as follows:
```hs
import           Data.Default.Class
import           QRandom
import           QRandom.Http

main :: IO ()
main = do
  bytes <- runQrandomHttp def (hex (Length 2) (BlockSize 10))
  print bytes

-- ["302670d0aae0163e0a60","8745e72c314a438eacc3"]
```
