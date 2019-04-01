import           Data.Default.Class
import           QRandom
import           QRandom.Http

main :: IO ()
main = do
  bytes <- runQrandomHttp def (hex (Length 2) (BlockSize 10))
  print bytes
