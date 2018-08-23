module Model exposing (Flags, Model, Repo, Route(..), StorageModel, User)

import Config exposing (Config)


type alias Model =
    { config : Config
    , inputText : String
    , userList : List User
    , selectedUserLogin : String
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


type alias StorageModel =
    { inputText : String
    , userList : List User
    , selectedUserLogin : String
    , userRepoList : List Repo
    }


type alias Flags =
    { config : Config
    , initialModel : StorageModel
    }
