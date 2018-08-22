module Model exposing (Model, Repo, Route(..), User)

import Config exposing (Config)


type alias Model =
    { config : Config
    , inputText : String
    , userList : List User
    , userRepoList : List Repo
    , route : Route
    }


type Route
    = HomeRoute
    | UserSearchRoute String
    | UserReposRoute String
    | NotFoundRoute


type alias User =
    { login : String
    , avatarUrl : String
    }


type alias Repo =
    { name : String
    , language : String
    , watchersCount : Int
    }
