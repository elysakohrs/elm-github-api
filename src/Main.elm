module Main exposing (init, initialModel, main)

import Commands exposing (requestUserRepos, requestUsers)
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
                currentRoute =
                    Routing.parseLocation location

                cmds =
                    case currentRoute of
                        UserSearchRoute searchQuery ->
                            getUserSearchCmds searchQuery flags.initialModel.userSearchQuery

                        UserReposRoute userLogin ->
                            getUserReposCmds userLogin flags.initialModel.selectedUserLogin

                        other ->
                            []
            in
            initialModel flags currentRoute ! cmds

        Err error ->
            Debug.crash error


getUserSearchCmds : String -> String -> List (Cmd Msg)
getUserSearchCmds urlSearchTerm storedInputText =
    if urlSearchTerm /= storedInputText then
        [ requestUsers urlSearchTerm ]

    else
        []


getUserReposCmds : String -> String -> List (Cmd Msg)
getUserReposCmds urlUserLogin selectedUserLogin =
    if urlUserLogin /= selectedUserLogin then
        [ requestUserRepos urlUserLogin ]

    else
        []


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
