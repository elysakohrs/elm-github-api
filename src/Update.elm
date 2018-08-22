module Update exposing (update)

import Commands exposing (..)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation exposing (newUrl)
import Routing exposing (parseLocation, usersPath)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInputText ->
            { model | inputText = newInputText } ! []

        -- Submit ->
        --     ( model, getUsers model.inputText )
        UpdateUserList result ->
            case result of
                Ok newSearchResult ->
                    { model | userList = newSearchResult } ! []

                Err _ ->
                    model ! []

        ClickUser login ->
            ( model, getUserRepos login )

        UpdateUserRepos repoList ->
            case repoList of
                Ok repoList ->
                    { model | userRepoList = repoList } ! []

                Err _ ->
                    model ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                _ =
                    Debug.log "new route" newRoute
            in
            case newRoute of
                HomeRoute ->
                    ( { model | route = newRoute }, Cmd.none )

                UserSearchRoute searchQuery ->
                    ( { model | route = newRoute }, getUsers searchQuery )

                UserReposRoute userLogin ->
                    ( { model | route = newRoute }, getUserRepos userLogin )

                NotFoundRoute ->
                    { model | route = newRoute } ! []

        ChangeLocation path ->
            let
                _ =
                    Debug.log "change location path" path
            in
            ( model, Navigation.newUrl path )
