module Commands exposing (repoDecoder, repoListDecoder, requestUserRepos, requestUsers, userDecoder, userSearchDecoder)

import Http
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Model exposing (..)
import Msg exposing (Msg(..))


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
