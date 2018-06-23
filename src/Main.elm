module Main exposing (main)

import Html
import Html.Styled exposing (..)
import Json.Decode as JD exposing (Value)
import Config exposing (Config)


-- MODEL --


type alias Model =
    { config : Config
    }


init : Value -> ( Model, Cmd Msg )
init configValue =
    case JD.decodeValue Config.configDecoder configValue of
        Ok config ->
            { config = config } ! []

        Err error ->
            Debug.crash error



-- UPDATE --


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW --


view : Model -> Html Msg
view model =
    text "Hello World!"



-- MAIN --


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view >> Html.Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
