module UserSearchView exposing (userSearchView)

import Css exposing (borderRadius, center, display, height, inlineBlock, margin, px, textAlign, width)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import Model exposing (Model, User)
import Msg exposing (Msg(..))


userSearchView : Model -> String -> Html Msg
userSearchView model searchQuery =
    div [ css [ textAlign center ] ]
        (List.map userToHtml model.userList)


userToHtml : User -> Html Msg
userToHtml user =
    div [ onClick (GetUserRepos user.login), css [ display inlineBlock ] ]
        [ img [ src user.avatarUrl, css [ width (px 70), height (px 70), borderRadius (px 35), margin (px 5) ] ] []
        ]
