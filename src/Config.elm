module Config exposing (Config, configDecoder)

import Date exposing (Date)
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Extra as JDE
import Json.Decode.Pipeline as JDP


type alias Config =
    { date : Date
    }


configDecoder : Decoder Config
configDecoder =
    JDP.decode Config
        |> JDP.required "date" JDE.date
