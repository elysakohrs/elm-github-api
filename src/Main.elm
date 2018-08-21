module Main exposing (main)

import Config exposing (Config)
import Html
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)



-- MODEL --


type alias Model =
    { config : Config
    , inputText : String
    , searchResult : String
    }


init : Value -> ( Model, Cmd Msg )
init configValue =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            { config = config, inputText = "", searchResult = "" } ! []

        Err error ->
            Debug.crash error



-- UPDATE --


type Msg
    = Change String
    | Submit
    | UpdateSearchResult (Result Http.Error SearchResult)


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
                    { model | searchResult = toString newSearchResult.users } ! []

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
        , div [] [ text model.searchResult ]
        , button [ onClick Submit ] [ text "Submit" ]
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


searchResultDecoder : Decoder SearchResult
searchResultDecoder =
    decode SearchResult
        |> required "total_count" JD.int
        |> required "incomplete_results" JD.bool
        |> required "items" (JD.list userDecoder)


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "login" JD.string
        |> required "avatar_url" JD.string


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
