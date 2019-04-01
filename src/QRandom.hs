{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveFunctor #-}
module QRandom
    ( Length(..)
    , BlockSize(..)
    , QRandom
    , ModeF(..)
    , word8
    , word16
    , hex
    ) where
import           Control.Monad.Free (Free, liftF)
import           Data.Text          (Text)
import           Data.Word          (Word16, Word8)

newtype Length = Length Word
newtype BlockSize = BlockSize Word

data ModeF a
  = Word8 Length ([Word8] -> a)
  | Word16 Length ([Word16] -> a)
  | Hex Length BlockSize ([Text] -> a)
  deriving (Functor)

type QRandom = Free ModeF

word8 :: Length -> QRandom [Word8]
word8 len = liftF $ Word8 len id

word16 :: Length -> QRandom [Word16]
word16 len = liftF $ Word16 len id

hex :: Length -> BlockSize -> QRandom [Text]
hex len size = liftF $ Hex len size id
