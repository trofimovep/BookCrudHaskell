{-# LANGUAGE OverloadedStrings #-}
module Main where

import Book (Book)
import Bookdb ( getAllBooks, getBookByName, saveBook, deleteBook )
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Web.Scotty ( get, json, middleware, scotty, param, ActionM, jsonData, post, delete )
import Data.Aeson.Types()
import Database.PostgreSQL.Simple ( Only(Only), query, connectPostgreSQL, query_ )
import Network.Wai.Middleware.Cors
    ( cors,
      simpleCorsResourcePolicy,
      CorsResourcePolicy(corsMethods, corsRequestHeaders) )

import Network.Wai (Middleware)

allowCors :: Middleware
allowCors = cors (const $ Just appCorsResourcePolicy)
appCorsResourcePolicy :: CorsResourcePolicy
appCorsResourcePolicy =
    simpleCorsResourcePolicy
        { corsMethods = ["DELETE", "GET", "POST"]
        , corsRequestHeaders = ["Authorization", "Content-Type"]
        }

main :: IO ()
main = do
  conn <- connectPostgreSQL "host='' dbname='bookdb' port=5432 user= password="

  scotty 8030 $ do
    middleware allowCors

    get "/api/v1/books" $ do
      books <- liftIO $ getAllBooks conn
      json books

    get "/api/v1/books/:name" $ do
      bookName <- param "name"
      booksWithName <- liftIO $ getBookByName conn bookName
      json booksWithName

    post "/api/v1/books" $ do
      newBook <- jsonData :: ActionM Book
      _ <- liftIO $ saveBook conn newBook
      books <- liftIO $ getAllBooks conn
      json books

    delete "/api/v1/books" $ do
      bookForDelete <- jsonData :: ActionM Book
      liftIO $ putStr $ show bookForDelete
      _ <- liftIO $ deleteBook conn bookForDelete
      books <- liftIO $ getAllBooks conn
      json books


