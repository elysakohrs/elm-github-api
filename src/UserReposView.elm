module UserReposView exposing (userReposView)

import Css exposing (border2, center, margin, px, solid, textAlign)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import Model exposing (Model, Repo)
import Msg exposing (Msg(..))


userReposView : Model -> String -> Html Msg
userReposView model userLogin =
    div [ css [ textAlign center ] ]
        (List.map repoToHtml model.userRepoList)


repoToHtml : Repo -> Html Msg
repoToHtml repo =
    div [ css [ border2 (px 1) solid, margin (px 5) ] ]
        [ div [] [ text repo.name ]
        , div [] [ text ("Language: " ++ repo.language) ]
        , div [] [ text ("Watchers: " ++ toString repo.watchersCount) ]
        ]
