module Msg exposing (Msg(..))

import Http
import Model exposing (Repo, User)
import Navigation exposing (Location)


type Msg
    = Change String
    | GetUsers String
    | UpdateUserList (Result Http.Error (List User))
    | GetUserRepos String
    | UpdateUserRepos (Result Http.Error (List Repo))
    | OnLocationChange Location
