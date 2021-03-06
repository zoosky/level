module Page.NewSpace exposing (Model, Msg(..), consumeEvent, init, setup, slugify, subscriptions, teardown, title, update, view)

import Avatar
import Browser.Navigation as Nav
import Connection exposing (Connection)
import Event exposing (Event)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onBlur, onClick, onInput)
import Mutation.CreateSpace as CreateSpace
import Query.Viewer as Viewer
import Regex exposing (Regex)
import Repo exposing (Repo)
import Route
import Session exposing (Session)
import Space exposing (Space)
import Task exposing (Task)
import User exposing (User)
import ValidationError exposing (ValidationError, errorView, isInvalid)
import Vendor.Keys as Keys exposing (Modifier(..), enter, onKeydown, preventDefault)
import View.Layout exposing (userLayout)



-- MODEL


type alias Model =
    { viewer : User
    , name : String
    , slug : String
    , errors : List ValidationError
    , formState : FormState
    }


type FormState
    = Idle
    | Submitting



-- PAGE PROPERTIES


title : String
title =
    "New Space"



-- LIFECYCLE


init : Session -> Task Session.Error ( Session, Model )
init session =
    session
        |> Viewer.request
        |> Task.andThen buildModel


buildModel : ( Session, Viewer.Response ) -> Task Session.Error ( Session, Model )
buildModel ( session, { viewer } ) =
    let
        model =
            Model viewer "" "" [] Idle
    in
    Task.succeed ( session, model )


setup : Model -> Cmd Msg
setup model =
    Cmd.none


teardown : Model -> Cmd Msg
teardown model =
    Cmd.none



-- UPDATE


type Msg
    = NameChanged String
    | SlugChanged String
    | Submit
    | Submitted (Result Session.Error ( Session, CreateSpace.Response ))


update : Msg -> Session -> Nav.Key -> Model -> ( ( Model, Cmd Msg ), Session )
update msg session navKey model =
    case msg of
        NameChanged val ->
            ( ( { model | name = val, slug = slugify val }, Cmd.none ), session )

        SlugChanged val ->
            ( ( { model | slug = val }, Cmd.none ), session )

        Submit ->
            let
                cmd =
                    session
                        |> CreateSpace.request model.name model.slug
                        |> Task.attempt Submitted
            in
            ( ( { model | formState = Submitting }, cmd ), session )

        Submitted (Ok ( _, CreateSpace.Success space )) ->
            ( ( model, Route.pushUrl navKey (Route.SetupCreateGroups <| Space.getSlug space) ), session )

        Submitted (Ok ( _, CreateSpace.Invalid errors )) ->
            ( ( { model | errors = errors, formState = Idle }, Cmd.none ), session )

        Submitted (Err _) ->
            ( ( { model | formState = Idle }, Cmd.none ), session )


specialCharRegex : Regex
specialCharRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "[^a-z0-9]+"


paddedDashRegex : Regex
paddedDashRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "(^-|-$)"


slugify : String -> String
slugify name =
    name
        |> String.toLower
        |> Regex.replace specialCharRegex (\_ -> "-")
        |> Regex.replace paddedDashRegex (\_ -> "")
        |> String.slice 0 20



-- EVENTS


consumeEvent : Event -> Model -> ( Model, Cmd Msg )
consumeEvent event model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Sub Msg
subscriptions =
    Sub.none



-- VIEW


type alias FormField =
    { type_ : String
    , name : String
    , placeholder : String
    , value : String
    , onInput : String -> Msg
    , autofocus : Bool
    }


view : Repo -> Model -> Html Msg
view repo model =
    userLayout model.viewer <|
        div
            [ classList
                [ ( "mx-auto max-w-sm leading-normal pb-8", True )
                , ( "shake", not (List.isEmpty model.errors) )
                ]
            ]
            [ div [ class "pb-6" ]
                [ h1 [ class "pb-4 font-extrabold text-3xl" ] [ text "Create a space" ]
                , p [] [ text "Spaces represent companies or organizations. Once you create your space, you can invite your colleagues to join." ]
                ]
            , div [ class "pb-6" ]
                [ label [ for "name", class "input-label" ] [ text "Name your space" ]
                , textField (FormField "text" "name" "Smith, Co." model.name NameChanged True) model.errors
                ]
            , div [ class "pb-6" ]
                [ label [ for "slug", class "input-label" ] [ text "Pick your URL" ]
                , slugField model.slug model.errors
                ]
            , button
                [ type_ "submit"
                , class "btn btn-blue"
                , onClick Submit
                , disabled (model.formState == Submitting)
                ]
                [ text "Let's get started" ]
            ]


textField : FormField -> List ValidationError -> Html Msg
textField field errors =
    let
        classes =
            [ ( "input-field w-full", True )
            , ( "input-field-error", isInvalid field.name errors )
            ]
    in
    div []
        [ input
            [ id field.name
            , type_ field.type_
            , classList classes
            , name field.name
            , placeholder field.placeholder
            , value field.value
            , onInput field.onInput
            , autofocus field.autofocus
            , onKeydown preventDefault [ ( [], enter, \event -> Submit ) ]
            ]
            []
        , errorView field.name errors
        ]


slugField : String -> List ValidationError -> Html Msg
slugField slug errors =
    let
        classes =
            [ ( "input-field inline-flex leading-none items-baseline", True )
            , ( "input-field-error", isInvalid "slug" errors )
            ]
    in
    div []
        [ div [ classList classes ]
            [ label
                [ for "slug"
                , class "flex-none text-dusty-blue-darker select-none"
                ]
                [ text "level.app/" ]
            , div [ class "flex-1" ]
                [ input
                    [ id "slug"
                    , type_ "text"
                    , class "placeholder-blue w-full p-0 no-outline text-dusty-blue-darker"
                    , name "slug"
                    , placeholder "smith-co"
                    , value slug
                    , onInput SlugChanged
                    , onKeydown preventDefault [ ( [], enter, \event -> Submit ) ]
                    ]
                    []
                ]
            ]
        , errorView "slug" errors
        ]
