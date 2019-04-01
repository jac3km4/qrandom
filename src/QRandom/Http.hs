{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
module QRandom.Http
  ( qrandomHttp
  , runQrandomHttp
  ) where
import           Control.Monad.Free     (foldFree)
import           Control.Monad.IO.Class (MonadIO)
import           Data.Aeson             (FromJSON (..), withObject, (.:))
import           Data.Text              (Text)
import           Network.HTTP.Req
import           QRandom

newtype Response a = Response { data' :: a }

instance (FromJSON a) => FromJSON (Response a) where
  parseJSON = withObject "Response" $ \v -> Response <$> v .: "data"

qrandomHttp :: MonadHttp m => ModeF a -> m a
qrandomHttp (Word8 (Length len) cont) =
  fmap cont . qrngRequest $ "type" =: ("uint8" :: Text) <> "length" =: len
qrandomHttp (Word16 (Length len) cont) =
  fmap cont . qrngRequest $ "type" =: ("uint16" :: Text) <> "length" =: len
qrandomHttp (Hex (Length len) (BlockSize size) cont) =
  fmap cont . qrngRequest $ "type" =: ("hex16" :: Text) <> "length" =: len <> "size" =: size

runQrandomHttp :: MonadIO m => HttpConfig -> QRandom a -> m a
runQrandomHttp conf = runReq conf . foldFree qrandomHttp

qrngRequest :: (MonadHttp m, FromJSON a) => Option 'Https -> m a
qrngRequest = fmap (data' . responseBody) .
  req GET (https "qrng.anu.edu.au" /: "API" /: "jsonI.php") NoReqBody jsonResponse
