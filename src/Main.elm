module Main exposing (init, initialModel, main)

import Commands exposing (getCommandsOnLocationChange, requestUserRepos, requestUsers)
import Html.Styled exposing (..)
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Model exposing (Flags, Model, Repo, Route(..), StorageModel, User)
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Ports exposing (flagsDecoder)
import Routing exposing (parseLocation)
import Subscription exposing (subscriptions)
import Update exposing (update, updateWithStorage)
import View exposing (view)


init : Value -> Location -> ( Model, Cmd Msg )
init flagsValue location =
    case JD.decodeValue flagsDecoder flagsValue of
        Ok flags ->
            let
                _ =
                    Debug.log "FLAGS" flags

                currentRoute =
                    Routing.parseLocation location

                startingModel =
                    initialModel flags currentRoute
            in
            getCommandsOnLocationChange startingModel

        Err error ->
            Debug.crash error


initialModel : Flags -> Route -> Model
initialModel flags route =
    { config = flags.config
    , inputText = ""
    , userSearchQuery = flags.initialModel.userSearchQuery
    , userList = flags.initialModel.userList
    , selectedUserLogin = flags.initialModel.selectedUserLogin
    , userRepoList = flags.initialModel.userRepoList
    , route = route
    }


main : Program Value Model Msg
main =
    Navigation.programWithFlags Msg.OnLocationChange
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = updateWithStorage
        , subscriptions = subscriptions
        }
