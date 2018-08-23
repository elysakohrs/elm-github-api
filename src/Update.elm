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
        Change newInputText ->
            { model | inputText = newInputText } ! []

        GetUsers searchQuery ->
            ( model, requestUsers searchQuery )

        UpdateUserList result ->
            case result of
                Ok newSearchResult ->
                    ( { model | userList = newSearchResult }, Cmd.batch [ Navigation.newUrl (usersPath model.inputText), sendToJs model ] )

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
            in
            { model | route = newRoute } ! []


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
        _ =
            Debug.log "model! " model

        storageModel =
            { inputText = model.inputText
            , userList = model.userList
            , selectedUserLogin = model.selectedUserLogin
            , userRepoList = model.userRepoList
            }
    in
    setJsStorage storageModel
