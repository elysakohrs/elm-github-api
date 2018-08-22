module Msg exposing (Msg(..))

import Http
import Model exposing (Repo, User)
import Navigation exposing (Location)


type Msg
    = Change String
    | UpdateUserList (Result Http.Error (List User))
    | ClickUser String
    | UpdateUserRepos (Result Http.Error (List Repo))
    | OnLocationChange Location
    | ChangeLocation String



-- | Submit
