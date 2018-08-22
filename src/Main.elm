module Main exposing (main)

import Config exposing (Config)
import Html
import Html.Styled exposing (..)
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Subscription exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


init : Value -> ( Model, Cmd Msg )
init configValue =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            { config = config, inputText = "", userList = [], userRepoList = [] } ! []

        Err error ->
            Debug.crash error


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
