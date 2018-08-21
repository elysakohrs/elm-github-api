module Main exposing (main)

import Config exposing (Config)
import Css exposing (border2, borderRadius, center, display, height, inlineBlock, margin, px, solid, textAlign, width)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline exposing (decode, optional, required)



-- MODEL --


type alias Model =
    { config : Config
    , inputText : String
    , userList : List User
    , userRepoList : List Repo
    }


init : Value -> ( Model, Cmd Msg )
init configValue =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            { config = config, inputText = "", userList = [], userRepoList = [] } ! []

        Err error ->
            Debug.crash error



-- UPDATE --


type Msg
    = Change String
    | Submit
    | UpdateUserList (Result Http.Error (List User))
    | ClickUser String
    | UpdateUserRepos (Result Http.Error (List Repo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInputText ->
            { model | inputText = newInputText } ! []

        Submit ->
            ( model, getUsers model.inputText )

        UpdateUserList result ->
            case result of
                Ok newSearchResult ->
                    { model | userList = newSearchResult } ! []

                Err _ ->
                    model ! []

        ClickUser login ->
            ( model, getUserRepos login )

        UpdateUserRepos repoList ->
            case repoList of
                Ok repoList ->
                    { model | userRepoList = repoList } ! []

                Err _ ->
                    model ! []



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW --


view : Model -> Html Msg
view model =
    div [ css [ textAlign center ] ]
        [ div []
            [ input [ onInput Change ] []
            , button [ onClick Submit ] [ text "Submit" ]
            ]
        , userListToHtml model.userList
        , repoListToHtml model.userRepoList
        ]


userListToHtml : List User -> Html Msg
userListToHtml userList =
    div []
        (List.map userToHtml userList)


userToHtml : User -> Html Msg
userToHtml user =
    div [ onClick (ClickUser user.login), css [ display inlineBlock ] ]
        [ img [ src user.avatarUrl, css [ width (px 70), height (px 70), borderRadius (px 35), margin (px 5) ] ] []
        ]


repoListToHtml : List Repo -> Html Msg
repoListToHtml repoList =
    div []
        (List.map repoToHtml repoList)


repoToHtml : Repo -> Html Msg
repoToHtml repo =
    div [ css [ border2 (px 1) solid, margin (px 5) ] ]
        [ div [] [ text repo.name ]
        , div [] [ text ("Language: " ++ repo.language) ]
        , div [] [ text ("Watchers: " ++ toString repo.watchersCount) ]
        ]



-- HTTP --


type alias User =
    { login : String
    , avatarUrl : String
    }


getUsers : String -> Cmd Msg
getUsers searchQuery =
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


type alias Repo =
    { name : String
    , language : String
    , watchersCount : Int
    }


getUserRepos : String -> Cmd Msg
getUserRepos userLogin =
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


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
