module Update exposing (apiUrl, update)

--import Json.Encode as Encode
--import Http
--import Material
--import Time as Time
--import Http

import Debug exposing (log)
import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Messages exposing (..)
import Models exposing (..)
import Ports exposing (..)


apiUrl : String
apiUrl =
    " http://34.225.216.131:5053/v1.0/events/sse/fa-status"


faStatusDecoder : Decoder FlightData
faStatusDecoder =
    decode FlightData
        |> required "status" string
        |> required "record_type" string
        |> required "origin" string
        |> required "id" string
        |> required "flight_ident" string
        |> required "flight_number" string
        |> required "airline" string
        |> required "estimated_arrival_time" int
        |> required "destination" string
        |> optional "arrival_time" int 0
        |> optional "progress_percent" int 0
        |> optional "depature_time" int 0
        |> required "cancelled" bool
        |> optional "arrival_delay" int 0
        |> optional "aircraft" string ""


updateFlightStatus : Model -> String -> Model
updateFlightStatus model payload =
    case decodeString faStatusDecoder payload of
        Ok faData ->
            { model | flights = Dict.insert faData.id faData model.flights }

        Err err ->
            log ("Failed to parse " ++ payload ++ " Error - " ++ err)
                model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( model, Cmd.none )

        InitApp ->
            log "Starting SSE REquest"
                ( model, ssePortRequest apiUrl )

        StatusEvent flightDataStr ->
            ( updateFlightStatus model flightDataStr, Cmd.none )
