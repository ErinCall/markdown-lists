{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString             (ByteString)
import           Data.Default                (def)
import           Data.Monoid                 (mempty)
import qualified Data.Text.Lazy              as L
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import qualified Text.Blaze.Renderer.XmlHtml as X
import           Text.Markdown               (markdown, MarkdownSettings(..))
import           Heist
import qualified Heist.Interpreted           as I
------------------------------------------------------------------------------
import           Application

markdownSplice :: Monad n => I.Splice n
markdownSplice = I.runNodeList $ X.renderHtmlNodes $ markdown settings $ L.intercalate "\n"
                [ "Here's some text that'll be in paragraph tags"
                , ""
                , "[Here's a link](https://git.andrewlorente.com/AndrewLorente/markdown-lists)"
                , ""
                , "Ok, here comes an unordered list:"
                , ""
                , "* first item"
                , "* second item"
                , "* third item"
                , ""
                , "And an ordered list:"
                , ""
                , "1. first item"
                , "1. second item"
                , "1. third item"
                , ""
                , "Isn't that messed up?"
                ]
  where
    settings = def { msXssProtect = False }

index :: Handler App App ()
index = method GET $ render "index"

routes :: [(ByteString, Handler App App ())]
routes = [ ("/",    ifTop index)
         , ("",     serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"

    let config = mempty {
        hcInterpretedSplices = "someRenderedMarkdown" ## markdownSplice
      }
    addRoutes routes
    addConfig h config
    return $ App h

