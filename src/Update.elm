module Update exposing (update)

import Commands exposing (..)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation exposing (newUrl)
import Routing exposing (parseLocation, reposPath, usersPath)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInputText ->
            { model | inputText = newInputText } ! []

        GetUsers searchQuery ->
            ( model, requestUsers searchQuery )

        UpdateUserList result ->
            case result of
                Ok newSearchResult ->
                    ( { model | userList = newSearchResult }, Navigation.newUrl (usersPath model.inputText) )

                Err _ ->
                    model ! []

        GetUserRepos userLogin ->
            ( { model | selectedUserLogin = userLogin }, requestUserRepos userLogin )

        UpdateUserRepos repoList ->
            case repoList of
                Ok repoList ->
                    ( { model | userRepoList = repoList }, Navigation.newUrl (reposPath model.selectedUserLogin) )

                Err _ ->
                    model ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                _ =
                    Debug.log "ON LOCSTION CHANGE" location
            in
            -- case newRoute of
            -- HomeRoute ->
            --     ( { model | route = newRoute }, Cmd.none )
            -- UserSearchRoute searchQuery ->
            --     ( { model | route = newRoute }, requestUsers searchQuery )
            -- UserReposRoute userLogin ->
            --     ( { model | route = newRoute }, getUserRepos userLogin )
            -- NotFoundRoute ->
            { model | route = newRoute } ! []

        ChangeLocation path ->
            ( model, Navigation.newUrl ("/" ++ path) )
