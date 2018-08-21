module Main exposing (main)

import Config exposing (Config)
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)



-- MODEL --


type alias Model =
    { config : Config
    , inputText : String
    , userList : List User
    }


init : Value -> ( Model, Cmd Msg )
init configValue =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            { config = config, inputText = "", userList = [] } ! []

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
        [ input [ onInput Change ] []
        , button [ onClick Submit ] [ text "Submit" ]
        , toHtmlList model.userList
        ]


toHtmlList : List User -> Html Msg
toHtmlList userList =
    ul []
        (List.map toLi userList)


toLi : User -> Html Msg
toLi user =
    div []
        [ text user.login
        , img [ src user.avatarUrl ] []
        ]



-- HTTP --


type alias SearchResult =
    { totalCount : Int
    , incompleteResults : Bool
    , users : List User
    }


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


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
