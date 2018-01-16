module Views exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Models exposing (..)
import Utility exposing (..)


--import Date
--import Time exposing (Time)
--import Debug exposing (log)


resetCardStyle : String -> String -> Attribute msg
resetCardStyle height margin =
    style
        [ ( "height", height )
        , ( "max-height", height )
        , ( "margin", margin )
        ]



--styleWidth width =
--style [ ( "width", width ) ]


fullWidthStyle : List ( String, String )
fullWidthStyle =
    [ ( "width", "100%" )
    , ( "padding", "0" )
    , ( "margin", "0" )
    , ( "height", "100vh" )
    ]


mainLayout : Html Msg -> Html Msg
mainLayout content =
    div [ class "mainwrapper", style fullWidthStyle ]
        [ div [ class "container", style fullWidthStyle ]
            [ div
                [ class "content", style fullWidthStyle ]
                [ content ]
            ]
        ]


msgBox : String -> String -> String -> Html Msg
msgBox qheading tooltip qnums =
    li [ class "cell" ]
        [ div [ title tooltip ]
            [ text qheading
            ]
        , div [ class "num" ]
            [ text qnums ]
        ]


faline : FlightData -> Html Msg
faline fadata =
    tr []
        [ td [ class "ident" ] [ text fadata.ident ]
        , td [ class "city" ] [ text fadata.origin ]
        , td [ class "time" ] []
        , td [ class "time" ] [ text (timeOfDay fadata.estimatedArrivalTime) ]
        , td [ style [ ( "width", "12%" ) ] ]
            [ div [ class "status", style [ ( "background", statusColor (String.concat (List.drop 1 (String.split " / " fadata.status))) ), ( "margin-left", "20px" ) ] ] [ text (String.concat (List.drop 1 (String.split " / " fadata.status))) ]
            ]
        ]


fsdline : FlightData -> Html Msg
fsdline fsddata =
    tr []
        [ td [ class "ident" ] [ text fsddata.ident ]
        , td [ class "city" ] [ text fsddata.destination ]
        , td [ class "time" ] [ text (timeOfDay fsddata.departureTime) ]
        , td [ class "time" ] [ text (timeOfDay fsddata.estimatedArrivalTime) ]
        , td [ style [ ( "width", "12%" ) ] ]
            [ div [ class "status", style [ ( "background", statusColor (String.concat (List.drop 1 (String.split " / " fsddata.status))) ), ( "margin-left", "20px" ) ] ] [ text (String.concat (List.drop 1 (String.split " / " fsddata.status))) ]
            ]
        ]


ferline : FlightData -> Html Msg
ferline ferdata =
    tr []
        [ td [ class "ident" ] [ text ferdata.ident ]
        , td [ class "city" ] [ text ferdata.origin ]
        , td [ class "time" ] []
        , td [ class "time" ] [ text (timeOfDay ferdata.estimatedArrivalTime) ]
        , td [ style [ ( "width", "12%" ) ] ]
            [ div [ class "progress_bar", style [ ( "color", "white" ), ( "margin-left", "20px" ) ] ]
                [ div [ class "progress", style [ ( "width", String.append (toString ferdata.progress) "%" ), ( "margin", "0em" ) ] ] []
                , div [ class "progressValue" ] [ text (String.append (toString ferdata.progress) "%") ]
                ]
            ]
        ]


fdline : FlightData -> Html Msg
fdline fddata =
    tr []
        [ td [ class "ident" ] [ text fddata.ident ]
        , td [ class "city" ] [ text fddata.destination ]
        , td [ class "time" ] []
        , td [ class "time" ] [ text (timeOfDay fddata.estimatedArrivalTime) ]
        , td [ style [ ( "width", "12%" ) ] ]
            [ div [ class "progress_bar", style [ ( "color", "white" ), ( "margin-left", "20px" ) ] ]
                [ div [ class "progress", style [ ( "width", String.append (toString fddata.progress) "%" ), ( "margin", "0em" ) ] ] []
                , div [ class "progressValue" ] [ text (String.append (toString fddata.progress) "%") ]
                ]
            ]
        ]


arrivalsView : Model -> Html Msg
arrivalsView model =
    let
        arrivals =
            Dict.values model.flights
                |> List.filter (\fdata -> fdata.recordType == "arrival" || fdata.recordType == "arrival")
                |> List.map (\flight -> faline flight)
    in
    table []
        [ tbody []
            arrivals
        ]


scheduledDeparturesView : Model -> Html Msg
scheduledDeparturesView model =
    let
        scheduledDepartures =
            Dict.values model.flights
                |> List.filter (\fdata -> fdata.recordType == "schedule" || fdata.recordType == "schedule")
                |> List.map (\flight -> fsdline flight)
    in
    table []
        [ tbody []
            scheduledDepartures
        ]


departuresView : Model -> Html Msg
departuresView model =
    let
        departures =
            Dict.values model.flights
                |> List.filter (\fdata -> fdata.recordType == "departure" || fdata.recordType == "departure")
                |> List.map (\flight -> fdline flight)
    in
    table []
        [ tbody []
            departures
        ]


enRoutesView : Model -> Html Msg
enRoutesView model =
    let
        enRoutes =
            Dict.values model.flights
                |> List.filter (\fdata -> fdata.recordType == "enroute" || fdata.recordType == "enroute")
                |> List.map (\flight -> ferline flight)
    in
    table []
        [ tbody []
            enRoutes
        ]


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ div [ style [ ( "margin-bottom", "1em" ) ] ]
            [ div [ style [ ( "background", "#4D4D4D" ) ] ]
                [ img [ src "/assets/images/ficon.png", alt "LOGO", class "logo", style [ ( "display", "inline-block" ), ( "width", "4em" ), ( "padding-right", "0.5em" ), ( "margin-bottom", "1em" ) ] ] []
                , h2 [ style [ ( "display", "inline-block" ), ( "width", "85%" ), ( "text-align", "left" ) ] ]
                    [ text "Flight Tracker" ]
                , h2 [ style [ ( "display", "inline-block" ), ( "text-align", "right" ), ( "padding-left", "0.5em" ), ( "border-left", "0.05em solid white" ) ] ]
                    [ text "DFW" ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "flightsbox" ]
                [ h5 [] [ text "Arrivals" ]
                , arrivalsView model
                ]
            , div [ class "flightsbox" ]
                [ h5 [] [ text "Scheduled Departures" ]
                , scheduledDeparturesView model
                ]
            ]
        , div [ class "row" ]
            [ div [ class "flightsbox" ]
                [ h5 [] [ text "En Route" ]
                , enRoutesView model
                ]
            , div [ class "flightsbox" ]
                [ h5 [] [ text "Departures" ]
                , departuresView model
                ]
            ]
        ]
