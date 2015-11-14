module Paths_keep (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/davidpdrsn/source/hacks/keep/.stack-work/install/x86_64-osx/lts-3.11/7.10.2/bin"
libdir     = "/Users/davidpdrsn/source/hacks/keep/.stack-work/install/x86_64-osx/lts-3.11/7.10.2/lib/x86_64-osx-ghc-7.10.2/keep-0.1.0.0-KYh2Q4l9AeO4sMkcPovc3q"
datadir    = "/Users/davidpdrsn/source/hacks/keep/.stack-work/install/x86_64-osx/lts-3.11/7.10.2/share/x86_64-osx-ghc-7.10.2/keep-0.1.0.0"
libexecdir = "/Users/davidpdrsn/source/hacks/keep/.stack-work/install/x86_64-osx/lts-3.11/7.10.2/libexec"
sysconfdir = "/Users/davidpdrsn/source/hacks/keep/.stack-work/install/x86_64-osx/lts-3.11/7.10.2/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "keep_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "keep_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "keep_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "keep_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "keep_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
