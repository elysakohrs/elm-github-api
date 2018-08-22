module Msg exposing (Msg(..))

import Http
import Model exposing (Repo, User)


type Msg
    = Change String
    | Submit
    | UpdateUserList (Result Http.Error (List User))
    | ClickUser String
    | UpdateUserRepos (Result Http.Error (List Repo))
