{-# LANGUAGE OverloadedStrings #-}
module Bookdb where
import Database.PostgreSQL.Simple ( FromRow, Connection, query_, query, Only (Only), execute )
import Book ( Book(..) )
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Data.Int (Int64)

getAllBooks :: Connection -> IO [Book]
getAllBooks conn = query_ conn "select * from books" :: IO [Book]

getBookByName :: Connection -> String -> IO [Book]
getBookByName conn bookName = query conn "select * from books where name = ?" [bookName]

saveBook :: Connection -> Book -> IO Int64
saveBook conn book = execute conn "insert into books (name, author, year) values (?,?,?)" [name book, author book, year book]

deleteBook :: Connection -> Book -> IO Int64
deleteBook conn book = execute conn "delete from books where name=? and author=? and year=?" [name book, author book, year book]

