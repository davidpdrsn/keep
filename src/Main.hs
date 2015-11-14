module Main where

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as LBS
import Data.Map (Map)
import Data.Maybe (fromJust)
import qualified Data.Map as M
import System.Directory (getHomeDirectory, doesFileExist)
import System.FilePath (joinPath)
import Control.Monad
import System.Environment (getArgs)
import Data.List

main :: IO ()
main = do
    args <- getArgs
    keep <- loadKeep
    keep' <- runKeepCommand args keep
    unless (keep == keep') $ persistKeep keep'

runKeepCommand :: [String] -> Keep -> IO Keep
runKeepCommand ["--help"] keep = showHelp >> return keep
runKeepCommand ["-h"] keep = showHelp >> return keep
runKeepCommand [listName, key, value] keep = do
    let keep' = insertPairToList key value listName keep
    putStrLn $ "Will keep \"" ++ key ++ "\" in \"" ++ listName ++ "\" as " ++ "\"" ++ value ++ "\""
    return keep'
runKeepCommand [listName, key] keep =
    case M.lookup listName keep of
      Nothing -> putStrLn "Didn't find that list" >> return keep
      Just list -> case M.lookup key list of
                     Nothing -> putStrLn ("Didn't find \"" ++ key ++ "\" in that list") >> return keep
                     Just value -> putStrLn value >> return keep
runKeepCommand [listName] keep =
    case M.lookup listName keep of
      Nothing -> do
        let keep' = createList listName keep
        putStrLn ("Will keep a list of \"" ++ listName ++ "\"")
        return keep'
      Just list -> do
        mapM_ (\(key, value) -> putStrLn $ key ++ " => " ++ value) $ M.toList list
        return keep
runKeepCommand [] keep = mapM_ putStrLn (listNames keep) >> return keep
runKeepCommand _ keep = putStrLn "Invalid args" >> return keep

showHelp :: IO ()
showHelp = putStrLn $ intercalate "\n" [ "Usage:"
                                       , "  Show all lists: keep"
                                       , "  Make a new list: keep <list name>"
                                       , "  Get key in list: keep <list name> <key>"
                                       , "  Add to list: keep <list name> <key> <value>"
                                       ]

type Keep = Map String (Map String String)

insertPairToList :: String -> String -> String -> Keep -> Keep
insertPairToList key value listName keep =
    case M.lookup listName keep of
      Just list -> let list' = M.insert key value list
                   in M.insert listName list' keep
      Nothing -> insertPairToList key value listName (createList listName keep)

createList :: String -> Keep -> Keep
createList name = M.insert name M.empty

listNames :: Keep -> [String]
listNames = M.keys

pairsInList :: String -> Keep -> Maybe [(String, String)]
pairsInList listName keep = M.toList <$> M.lookup listName keep

persistKeep :: Keep -> IO ()
persistKeep keep = do
    path <- keepPath
    LBS.writeFile path $ encode keep
    return ()

keepPath :: IO FilePath
keepPath = do
    home <- getHomeDirectory
    return $ joinPath [home, ".keep.json"]

loadKeep :: IO Keep
loadKeep = do
    path <- keepPath
    ifM (doesFileExist path)
      (liftM (fromJust . decode) $ LBS.readFile path)
      (persistKeep M.empty >> loadKeep)

ifM :: Monad m => m Bool -> m a -> m a -> m a
ifM m t e = do
    x <- m
    if x then t else e
