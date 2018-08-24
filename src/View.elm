module View exposing (view)

import Css exposing (center, textAlign)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, value)
import Html.Styled.Events exposing (onClick, onInput)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Routing exposing (usersPath)
import UserReposView exposing (userReposView)
import UserSearchView exposing (userSearchView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Model.HomeRoute ->
            homeView model

        Model.UserSearchRoute searchQuery ->
            userSearchView model searchQuery

        Model.UserReposRoute userLogin ->
            userReposView model userLogin

        Model.NotFoundRoute ->
            notFoundView


homeView : Model -> Html Msg
homeView model =
    div [ css [ textAlign center ] ]
        [ div []
            [ input [ onInput UpdateInput ] []
            , button [ onClick (ChangeLocation (usersPath model.inputText)) ] [ text "Submit" ]
            ]
        ]


notFoundView : Html Msg
notFoundView =
    div [ css [ textAlign center ] ]
        [ div []
            [ text "NOT FOUND VIEW"
            ]
        ]
