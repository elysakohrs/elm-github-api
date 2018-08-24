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
                _ =
                    Debug.log "FLAGS" flags

                currentRoute =
                    Routing.parseLocation location

                startingModel =
                    initialModel flags currentRoute
            in
            case currentRoute of
                HomeRoute ->
                    ( startingModel, Cmd.none )

                UserSearchRoute searchQuery ->
                    checkNeedToRequestUsers searchQuery startingModel

                UserReposRoute userLogin ->
                    checkNeedToRequestRepos userLogin startingModel

                NotFoundRoute ->
                    startingModel ! []

        Err error ->
            Debug.crash error


checkNeedToRequestUsers : String -> Model -> ( Model, Cmd Msg )
checkNeedToRequestUsers routeSearchQuery model =
    if routeSearchQuery /= model.userSearchQuery then
        ( { model | userSearchQuery = routeSearchQuery }, requestUsers routeSearchQuery )

    else
        model ! []


checkNeedToRequestRepos : String -> Model -> ( Model, Cmd Msg )
checkNeedToRequestRepos routeUserLogin model =
    if routeUserLogin /= model.selectedUserLogin then
        ( { model | selectedUserLogin = routeUserLogin }, requestUserRepos routeUserLogin )

    else
        model ! []


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
