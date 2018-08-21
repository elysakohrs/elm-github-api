module Main exposing (main)

import Config exposing (Config)
import Html
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD exposing (Decoder, Value)



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
    | UpdateSearchResult (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInputText ->
            { model | inputText = newInputText } ! []

        Submit ->
            ( model, searchGit model.inputText )

        UpdateSearchResult (Ok newSearchResult) ->
            ( { model | searchResult = newSearchResult }, Cmd.none )

        UpdateSearchResult (Err _) ->
            ( model, Cmd.none )



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


searchGit : String -> Cmd Msg
searchGit searchQuery =
    let
        url =
            "https://api.github.com/search/users?q=" ++ searchQuery

        request =
            Http.getString url
    in
    Http.send UpdateSearchResult request


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
