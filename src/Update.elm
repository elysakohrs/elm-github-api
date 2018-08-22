module Update exposing (update)

import Commands exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInputText ->
            { model | inputText = newInputText } ! []

        Submit ->
            ( model, getUsers model.inputText )

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
