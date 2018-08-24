module Update exposing (update, updateWithStorage)

import Commands exposing (..)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation exposing (newUrl)
import Ports exposing (setJsStorage)
import Routing exposing (parseLocation, reposPath, usersPath)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInput newInputText ->
            { model | inputText = newInputText } ! []

        UpdateUserList result ->
            case result of
                Ok newSearchResult ->
                    ( { model | userList = newSearchResult }, sendToJs model )

                Err _ ->
                    model ! []

        UpdateUserRepos repoList ->
            case repoList of
                Ok repoList ->
                    ( { model | userRepoList = repoList }, sendToJs model )

                Err _ ->
                    model ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            case newRoute of
                HomeRoute ->
                    { model | route = newRoute } ! []

                UserSearchRoute searchQuery ->
                    ( { model | route = newRoute, userSearchQuery = searchQuery }, requestUsers searchQuery )

                UserReposRoute userLogin ->
                    ( { model | route = newRoute, selectedUserLogin = userLogin }, requestUserRepos userLogin )

                NotFoundRoute ->
                    { model | route = newRoute } ! []

        ChangeLocation path ->
            ( model, Navigation.newUrl path )


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
    ( newModel, Cmd.batch [ sendToJs newModel, cmds ] )


sendToJs : Model -> Cmd Msg
sendToJs model =
    let
        storageModel =
            { userSearchQuery = model.userSearchQuery
            , userList = model.userList
            , selectedUserLogin = model.selectedUserLogin
            , userRepoList = model.userRepoList
            }
    in
    setJsStorage storageModel
