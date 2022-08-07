{-# LANGUAGE DeriveGeneric #-}
module Book where

  import Data.Aeson (ToJSON, FromJSON)
  import GHC.Generics (Generic)
  import Database.PostgreSQL.Simple.FromRow (FromRow (fromRow), field)

  data Book = Book {
    name :: String,
    author :: String,
    year :: String
  } deriving (Generic, Show)


  instance ToJSON Book
  instance FromJSON Book
  instance FromRow Book where
    fromRow = Book <$> field <*> field <*> field