'use strict'
angular.module('app.contacts', [])
# --------------------------------------------
# Contact in Handbook TAB of Client
# 1. manage list contacts
# 2. Autocomplete email
.controller('ContactCtrl', [
    '$scope', '$filter' , 'fetchTabData', 'fakeData', '$location', '$routeParams', 'ContactService', 'fetchContact', 'SearchUsers', 'fetchUsers', 'config' , '$q', '$modal',
    ($scope, $filter, fetchTabData, fakeData, $location, $routeParams, ContactService, fetchContact, SearchUsers, fetchUsers, config, $q, $modal) ->



        # 1. manage list contacts
        $scope.loadContactList = ->
            ContactService.get {org_id:$routeParams.clientId}, (data, getResponseHeaders) ->
                if data._embedded.items.length
                    $scope.contacts = []
                    for i, item of data._embedded.items
                        ((itemInstance) ->
                            fetchContact.get(itemInstance._links.employee.href).then  (res) ->
                                $scope.contacts.push({
                                    'position': itemInstance
                                    'user' : res.data
                                    'alphabet' : res.data.first_name.charAt(0).toLowerCase()
                                })
                        )(item)

                return

        if $routeParams.clientId
            $scope.loadContactList()

        # 2. Autocomplete email
        $scope.contact = {
            email: ''
            title: ''
        }

        $scope.srch_users   =
            'email' : 0

        $scope.searchMail = (term) ->
            d = $q.defer()
            q = term.toLowerCase().trim()
            results = {}

            fetchUsers.get(config.path.baseURL + config.path.users + '?search=user.email:%'+q+'%').then (res) ->

                if res.data._embedded
                    $scope.srch_users = {}
                    users = res.data._embedded.items
                    for i in [0...users.length]
                        item = users[i]
                        results[item.email] = item.id
                    $scope.srch_users = results
                    d.resolve(results)
                else
                    return
            , () ->
                d.resolve(results)
            return d.promise


        # 3. create contact
        $scope.selectedUser = null
        $scope.createContact = ->
            angular.forEach $scope.frm_contact.$error.required, (field)->
                field.$dirty = true
            if $scope.frm_contact.$error.required.length
                return false

            newContact = {
                "position": {
                    "title": $scope.contact.title
                    "employee": $scope.srch_users[$scope.contact.email]
                    "active": true
                    "employer": $routeParams.clientId
                }
            }
            ContactService.save {org_id:$routeParams.clientId}, newContact, (res)->
                $scope.loadContactList()


        # 4.delete contact
        $scope.deleteContact = (contact) ->
            r = confirm("Do you want to delete \"" + contact.position.title + "\"?")
            if r == true
                fetchContact.delete contact.position._links.self.href
                .then (res) ->
                    $scope.loadContactList()
            # modalInstance = $modal.open {
            #     templateUrl: 'views/handbooks/delete_contact.html'
            #     controller: 'DeleteContactCtrl'
            #     resolve: {
            #         contact: ->
            #             return contact
            #     }
            #     scope: $scope
            # }

        # 5. submit contact form
        $scope.contact_submit = ()->
            angular.forEach $scope.frm_contact.$error.required, (field)->
                console.log field
                field.$dirty = true

        # 6. edit contact
        $scope.editContact = (contact) ->
            $scope.editcontact = contact
            modalInstance = $modal.open {
                templateUrl: 'views/handbooks/contact_form.html'
                controller: 'ContactFormCtrl'
                resolve: {
                    contact: ->
                        return contact
                }
                scope: $scope
            }

        # 7. count selected item
        $scope.totalSelected = 0
        $scope.contactSelect = ->
            $scope.totalSelected = 0
            for i, item of $scope.contacts
                if item.checked == true
                    $scope.totalSelected++

        # 8. Delete selected contact
        $scope.deleteSelectedContacts = ->
            r = confirm("Do you want to delete all select contact?")
            count = 0
            if r == true
                for i, item of $scope.contacts
                    if item.checked == true
                        fetchContact.delete item.position._links.self.href
                        .then (res) ->
                            count++
                            if count == $scope.totalSelected
                                $scope.loadContactList()
                                
        return
])
.controller('ContactFormCtrl', [
    '$scope', '$routeParams', 'fetchContact', 'config', '$modalInstance', 'contact'
    ($scope, $routeParams, fetchContact, config, $modalInstance, contact) ->
        $scope.contact = contact
        $scope.save = ->
            updateContact = {
                "position": {
                    "title": contact.position.title
                    "employee": $scope.srch_users[contact.user.email]
                    "active": true
                    "employer": $routeParams.clientId
                }
            }
            fetchContact.update(contact.position._links.self.href, updateContact).then  (res) ->
                $scope.loadContactList()
                $modalInstance.close()
        $scope.cancel = ->
            $modalInstance.dismiss('cancel');
])
# .controller('DeleteContactCtrl', [
#     '$scope', '$routeParams', 'fetchContact', 'config', '$modalInstance', 'contact'
#     ($scope, $routeParams, fetchContact, config, $modalInstance, contact) ->
#         $scope.contact = contact
#         $scope.confirm = ->
#             fetchContact.delete contact.position._links.self.href
#             .then (res) ->
#                 $scope.loadContactList()
#                 $modalInstance.close()
#         $scope.cancel = ->
#             $modalInstance.dismiss('cancel');
# ])
.directive('keyboardPoster',
    ($parse, $timeout) ->
        DELAY_TIME_BEFORE_POSTING = 1000;
        return (scope, elem, attrs) ->
            element = angular.element(elem)[0];
            currentTimeout = null;

            element.oninput = () ->
                model  = $parse(attrs.postFunction);
                poster = model(scope);

                if(currentTimeout)
                    $timeout.cancel(currentTimeout)

                currentTimeout = $timeout( () ->
                    poster angular.element(element).val()
                    return
                , DELAY_TIME_BEFORE_POSTING)
                return
            return
)



