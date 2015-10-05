'use strict'
angular.module('app.handbook_info', [])
# --------------------------------------------

.controller('HandbookInfoCtrl', [
    '$scope', '$routeParams', 'handbookService', 'clientService', 'sectionService', '$location', '$timeout',
    ($scope, $routeParams, handbookService, clientService, sectionService, $location, $timeout) ->

        $scope.clientId = $routeParams.clientId
        $scope.handbookId = $routeParams.handbookId

        clientService.get {org_id:$scope.clientId}, (data, getResponseHeaders) ->
            $scope.clientDetail = data

        if $scope.isCreateHandbook == false
            handbookService.get {org_id:$scope.clientId, hand_id:$scope.handbookId}, (data, getResponseHeaders) ->
                $scope.handbook = data

        $scope.isActive = (href) ->
            path = $location.path()
            if path.indexOf(href) is 0
              return 'active'

        $scope.submitHandbookInfo = ->
            angular.forEach $scope.frm_crt_handbook.$error.required, (field)->
                field.$dirty = true
            if $scope.frm_crt_handbook.$error.required.length
                return false

            updateData = {
                handbook: $scope.handbook
            }
            delete updateData.handbook._links
            delete updateData.handbook.id
            updateData.handbook['organisation'] = $scope.clientId
            handbookService.update {org_id:$scope.clientId, hand_id:$scope.handbookId}, updateData

            # display message
            $scope.infoUpdated = 'Update Success'
            $timeout ()->
                $scope.infoUpdated = null
            , 3000

        $scope.submitCreateHandbook = ->
            angular.forEach $scope.frm_crt_handbook.$error.required, (field)->
                field.$dirty = true
            if $scope.frm_crt_handbook.$error.required.length
                return false

            newData = {
                handbook: {
                    version: $scope.handbook.version
                    title: $scope.handbook.title
                    year: $scope.handbook.year
                    description: $scope.handbook.description
                    organisation: $scope.clientId
                }
            }
            handbookService.save {org_id:$scope.clientId}, newData

            # display message
            $scope.infoUpdated = 'Save Success'
            $timeout ()->
                $scope.infoUpdated = null
            , 3000
])
