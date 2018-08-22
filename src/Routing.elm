module Routing exposing (matchers, parseLocation, reposPath, usersPath)

import Model exposing (Route(..))
import Navigation exposing (Location)
import UrlParser exposing ((</>), Parser, map, oneOf, parsePath, s, string, top)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeRoute top
        , map UserSearchRoute (s "users" </> string)
        , map UserReposRoute (s "repos" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


usersPath : String -> String
usersPath searchQuery =
    "/users/" ++ searchQuery


reposPath : String -> String
reposPath userLogin =
    "/repos/" ++ userLogin
