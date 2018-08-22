module UserSearchView exposing (userListToHtml, userToHtml, view)


view : Model -> Html Msg
view model =
    div [ css [ textAlign center ] ]
        [ div []
            [ input [ onInput Change ] []
            , button [ onClick Submit ] [ text "Submit" ]
            ]
        , userListToHtml model.userList
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
