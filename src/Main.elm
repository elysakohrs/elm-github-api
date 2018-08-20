module Main exposing (main)

import Config exposing (Config)
import Html
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Json.Decode as JD exposing (Value)



-- MODEL --


type alias Model =
    { config : Config
    , val : Int
    }


init : Value -> ( Model, Cmd Msg )
init configValue =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            { config = config, val = 0 } ! []

        Err error ->
            Debug.crash error



-- UPDATE --


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            { model | val = model.val + 1 } ! []

        Decrement ->
            { model | val = model.val - 1 } ! []



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW --


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.val) ]
        , button [ onClick Increment ] [ text "+" ]
        ]



-- MAIN --


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
