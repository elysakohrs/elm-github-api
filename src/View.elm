module View exposing (repoListToHtml, repoToHtml, view)

import Css exposing (border2, borderRadius, center, display, height, inlineBlock, margin, px, solid, textAlign, width)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events exposing (onClick, onInput)
import Model exposing (Model, Repo, User)
import Msg exposing (..)
import Routing exposing (usersPath)


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
            userSearchResultsView model searchQuery

        Model.UserReposRoute userLogin ->
            userReposView model userLogin

        Model.NotFoundRoute ->
            notFoundView


homeView : Model -> Html Msg
homeView model =
    div [ css [ textAlign center ] ]
        [ div []
            [ input [ onInput Change ] []
            , button [ onClick (ChangeLocation (usersPath model.inputText)) ] [ text "Submit" ]
            ]
        ]


userSearchResultsView : Model -> String -> Html Msg
userSearchResultsView model searchQuery =
    div [ css [ textAlign center ] ]
        (List.map userToHtml model.userList)


userReposView : Model -> String -> Html Msg
userReposView model userLogin =
    div [ css [ textAlign center ] ]
        [ div []
            [ text "USER REPOS VIEW"
            ]
        ]


notFoundView : Html Msg
notFoundView =
    div [ css [ textAlign center ] ]
        [ div []
            [ text "NOT FOUND VIEW"
            ]
        ]


userListToHtml : List User -> Html Msg
userListToHtml userList =
    div []
        (List.map userToHtml userList)


userToHtml : User -> Html Msg
userToHtml user =
    div [ onClick (ClickUser user.login), css [ display inlineBlock ] ]
        [ img [ src user.avatarUrl, css [ width (px 70), height (px 70), borderRadius (px 35), margin (px 5) ] ] []
        ]


repoListToHtml : List Repo -> Html Msg
repoListToHtml repoList =
    div []
        (List.map repoToHtml repoList)


repoToHtml : Repo -> Html Msg
repoToHtml repo =
    div [ css [ border2 (px 1) solid, margin (px 5) ] ]
        [ div [] [ text repo.name ]
        , div [] [ text ("Language: " ++ repo.language) ]
        , div [] [ text ("Watchers: " ++ toString repo.watchersCount) ]
        ]