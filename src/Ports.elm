port module Ports exposing (emptyStorageModel, flagsDecoder, repoStorageModelDecoder, setJsStorage, storageModelDecoder, userStorageModelDecoder)

import Config exposing (configDecoder)
import Json.Decode as JD exposing (Decoder, Value, field, int, list, string)
import Json.Decode.Pipeline as JDP exposing (optional, required)
import Model exposing (Flags, Repo, StorageModel, User)


port setJsStorage : StorageModel -> Cmd msg


emptyStorageModel : StorageModel
emptyStorageModel =
    { userSearchQuery = ""
    , userList = []
    , selectedUserLogin = ""
    , userRepoList = []
    }


flagsDecoder : Decoder Flags
flagsDecoder =
    JDP.decode Flags
        |> required "config" configDecoder
        |> optional "initialState" storageModelDecoder emptyStorageModel


storageModelDecoder : Decoder StorageModel
storageModelDecoder =
    JDP.decode StorageModel
        |> required "userSearchQuery" JD.string
        |> required "userList" (JD.list userStorageModelDecoder)
        |> required "selectedUserLogin" JD.string
        |> required "userRepoList" (JD.list repoStorageModelDecoder)


userStorageModelDecoder : Decoder User
userStorageModelDecoder =
    JDP.decode User
        |> required "login" JD.string
        |> required "avatarUrl" JD.string


repoStorageModelDecoder : Decoder Repo
repoStorageModelDecoder =
    JDP.decode Repo
        |> required "name" JD.string
        |> required "language" JD.string
        |> required "watchersCount" JD.int
