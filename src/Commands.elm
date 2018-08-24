module Commands exposing (getCommandsOnLocationChange, repoDecoder, repoListDecoder, requestUserRepos, requestUsers, userDecoder, userSearchDecoder)

import Http
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Model exposing (..)
import Msg exposing (Msg(..))


getCommandsOnLocationChange : Model -> ( Model, Cmd Msg )
getCommandsOnLocationChange model =
    case model.route of
        HomeRoute ->
            model ! []

        UserSearchRoute searchQuery ->
            checkNeedToRequestUsers searchQuery model

        UserReposRoute userLogin ->
            checkNeedToRequestRepos userLogin model

        NotFoundRoute ->
            model ! []


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


requestUsers : String -> Cmd Msg
requestUsers searchQuery =
    let
        url =
            "https://api.github.com/search/users?q=" ++ searchQuery

        request =
            Http.get url userSearchDecoder
    in
    Http.send UpdateUserList request


userSearchDecoder : Decoder (List User)
userSearchDecoder =
    JD.field "items" (JD.list userDecoder)


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "login" JD.string
        |> required "avatar_url" JD.string


requestUserRepos : String -> Cmd Msg
requestUserRepos userLogin =
    let
        url =
            "https://api.github.com/users/" ++ userLogin ++ "/repos"

        request =
            Http.get url repoListDecoder
    in
    Http.send UpdateUserRepos request


repoListDecoder : Decoder (List Repo)
repoListDecoder =
    JD.list repoDecoder


repoDecoder : Decoder Repo
repoDecoder =
    decode Repo
        |> required "name" JD.string
        |> optional "language" JD.string ""
        |> required "watchers_count" JD.int
