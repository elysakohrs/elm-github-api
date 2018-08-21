module Main exposing (main)

import Config exposing (Config)
import Css exposing (borderRadius, display, height, inlineBlock, px, width)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)



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
    | UpdateSearchResult (Result Http.Error (List User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInputText ->
            { model | inputText = newInputText } ! []

        Submit ->
            ( model, searchGit model.inputText )

        UpdateSearchResult result ->
            case result of
                Ok newSearchResult ->
                    { model | userList = newSearchResult } ! []

                Err _ ->
                    model ! []



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW --


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput Change ] []
            , button [ onClick Submit ] [ text "Submit" ]
            ]
        , toHtmlList model.userList
        ]


toHtmlList : List User -> Html Msg
toHtmlList userList =
    div []
        (List.map toLi userList)


toLi : User -> Html Msg
toLi user =
    div [ css [ display inlineBlock ] ]
        [ img [ src user.avatarUrl, css [ width (px 70), height (px 70), borderRadius (px 35) ] ] []
        ]



-- HTTP --


type alias User =
    { login : String
    , avatarUrl : String
    }


searchGit : String -> Cmd Msg
searchGit searchQuery =
    let
        url =
            "https://api.github.com/search/users?q=" ++ searchQuery

        request =
            Http.get url searchResultDecoder
    in
    Http.send UpdateSearchResult request


searchResultDecoder : Decoder (List User)
searchResultDecoder =
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


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
