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
import qualified Text.Blaze.Renderer.XmlHtml as X (renderHtml)
import           Text.Markdown               (markdown, MarkdownSettings(..))
import qualified Text.XmlHtml                as X
import           Heist
import qualified Heist.Interpreted           as I
------------------------------------------------------------------------------
import           Application

markdownSplice :: Monad n => I.Splice n
markdownSplice = I.runNodeList $ X.docContent $ X.renderHtml $ markdown settings $ L.concat
                [ "* first item"
                , "* second item"
                , "* third item"
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

