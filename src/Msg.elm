module Msg exposing (Msg(..))

import Http
import Model exposing (Repo, User)
import Navigation exposing (Location)


type Msg
    = UpdateInput String
    | UpdateUserList (Result Http.Error (List User))
    | UpdateUserRepos (Result Http.Error (List Repo))
    | OnLocationChange Location
    | ChangeLocation String
