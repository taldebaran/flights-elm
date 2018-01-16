module Utility exposing (..)

import Date
import Dict exposing (Dict)
import Time exposing (Time)


durationFormat : Int -> String
durationFormat duration =
    let
        ( acc, _ ) =
            List.foldl
                (\p ( a, dur ) ->
                    ( (if dur > p then
                        toString (dur // p) |> String.padLeft 2 '0'
                       else
                        "00"
                      )
                        :: a
                    , dur % p
                    )
                )
                ( [], duration // 1000 )
                [ 3600, 60, 1 ]

        upd =
            acc |> List.reverse |> String.join ":"
    in
    if String.left 3 upd == "00:" then
        String.right 5 upd
    else
        upd


statusColor : String -> String
statusColor status =
    if status == "Delayed" then
        "red"
    else
        "green"


timeOfDay : Int -> String
timeOfDay millis =
    let
        dd =
            Date.fromTime (toFloat millis)
    in
    String.append
        ([ Date.hour dd, Date.minute dd ]
            |> List.map (\n -> n |> toString |> String.padLeft 2 '0')
            |> String.join ":"
        )
        " CST"


getOrElse : Dict comparable b -> comparable -> b -> b
getOrElse dict key default =
    case Dict.get key dict of
        Just v ->
            v

        Nothing ->
            default
