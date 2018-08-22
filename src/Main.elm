module Main exposing (main)

import Config exposing (Config)
import Html.Styled exposing (..)
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Routing exposing (parseLocation)
import Subscription exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


init : Value -> Location -> ( Model, Cmd Msg )
init configValue location =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            let
                currentRoute =
                    Routing.parseLocation location
            in
            initialModel config currentRoute ! []

        Err error ->
            Debug.crash error


initialModel : Config -> Route -> Model
initialModel config route =
    { config = config
    , inputText = ""
    , userList = []
    , selectedUserLogin = ""
    , userRepoList = []
    , route = route
    }


main : Program Value Model Msg
main =
    Navigation.programWithFlags Msg.OnLocationChange
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
