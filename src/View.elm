module View exposing (repoListToHtml, repoToHtml, userListToHtml, userToHtml, view)

import Css exposing (border2, borderRadius, center, display, height, inlineBlock, margin, px, solid, textAlign, width)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick, onInput)
import Model exposing (Model, Repo, User)
import Msg exposing (..)


view : Model -> Html Msg
view model =
    div [ css [ textAlign center ] ]
        [ div []
            [ input [ onInput Change ] []
            , button [ onClick Submit ] [ text "Submit" ]
            ]
        , userListToHtml model.userList
        , repoListToHtml model.userRepoList
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
