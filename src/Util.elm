module Util exposing (msgAsCmd, removeNonNumerals, toMinSec)

import Char exposing (isDigit)
import String exposing (filter, right, slice)
import Task exposing (perform, succeed)


msgAsCmd : msg -> Cmd msg
msgAsCmd msg =
    Task.perform (\_ -> msg) (succeed msg)



-- UTIL
-- If the Strings last 1-4 letters are digits it parses them to
-- minutes and seconds


toMinSec : String -> Maybe Int
toMinSec textTime =
    textTime |> removeNonNumerals |> numSlicer


removeNonNumerals : String -> String
removeNonNumerals =
    filter isDigit


numSlicer : String -> Maybe Int
numSlicer textTime =
    let
        mins =
            slice -4 -2 textTime

        sec =
            right 2 textTime

        minSec =
            ( toParsedTime mins, toParsedTime sec )
    in
    case minSec of
        ( Nothing, Just seconds ) ->
            Just seconds

        ( Just minutes, Just seconds ) ->
            Just (60 * minutes + seconds)

        _ ->
            Nothing


toParsedTime : String -> Maybe Int
toParsedTime timeToParse =
    case String.toInt timeToParse of
        Ok timeValue ->
            Just timeValue

        Err _ ->
            Nothing
