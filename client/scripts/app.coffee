'use strict'

angular.module('app', [
    # Angular modules
    'ngRoute'
    'ngAnimate'
    'ngResource'
    'hateoas'

    # 3rd Party Modules
    'ui.bootstrap'
    'easypiechart'
    'mgo-angular-wizard'
    'textAngular'
    'ui.tree'
    'ngMap'
    'ngTagsInput'
    'duScroll'
    'ui.tinymce'
    
    # Custom modules
    'app.constant'
    'app.controllers'
    'app.directives'
    'app.localization'
    'app.nav'
    'app.ui.ctrls'
    'app.ui.directives'
    'app.ui.services'
    'app.ui.map'
    'app.form.validation'
    'app.ui.form.ctrls'
    'app.ui.form.directives'
    'app.tables'
    'app.task'
    'app.chart.ctrls'
    'app.chart.directives'
    'app.page.ctrls'
    'app.merchants'
    'app.clients'
    'app.client.services'
    'app.handbook.services'
    'app.handbook.sections.services'
    'app.links.services'
    'app.contacts'
    'app.contacts.services'
    #Khai bao app khi tao
])
    
.config([
    '$routeProvider', 'HateoasInterceptorProvider', 'HateoasInterfaceProvider', '$sceDelegateProvider', '$httpProvider',
    ($routeProvider, HateoasInterceptorProvider, HateoasInterfaceProvider, $sceDelegateProvider, $httpProvider) ->

        routes = [
            'dashboard'
            'ui/typography', 'ui/buttons', 'ui/icons', 'ui/grids', 'ui/widgets', 'ui/components', 'ui/timeline', 'ui/nested-lists', 'ui/pricing-tables', 'ui/maps'
            'tables/static', 'tables/dynamic', 'tables/responsive'
            'forms/elements', 'forms/layouts', 'forms/validation', 'forms/wizard'
            'charts/charts', 'charts/flot', 'charts/morris'
            'pages/404', 'pages/500', 'pages/blank', 'pages/forgot-password', 'pages/invoice', 'pages/lock-screen', 'pages/profile', 'pages/signin', 'pages/signup'
            'mail/compose', 'mail/inbox', 'mail/single'
            'tasks/tasks'
            'merchants/list-merchant', 'merchants/add', 'merchants/view', 'merchants/company', 'merchants/edit_company'
            # CLIENT MANAGEMENT
            'clients/list-clients',
            'clients/add',
            'clients/view',
            'clients/company',
            'clients/edit_company',
            'clients/create-new-handbook',
            'clients/tab-view',
            'clients/client',
            'clients/client-user',
            'clients/client-handbook',
            'clients/client-policies',
            'clients/client-insurance',
            'clients/client-healthcare',
            'clients/client-imerchant'
        ]

        setRoutes = (route) ->
            url = '/' + route
            config =
                templateUrl: 'views/' + route + '.html'

            $routeProvider.when(url, config)
            return $routeProvider

        routes.forEach( (route) ->
            setRoutes(route)
        )

        # SET ROUTE MANUAL ---------------------------------------
        $routeProvider
            .when('/', { redirectTo: '/merchants/list-merchant'} )
            .when('/404', { templateUrl: 'views/pages/404.html'} )

        $routeProvider
            .when('/clients/:clientId/handbooks/:handbookId', {
                templateUrl: 'views/handbooks/handbook.html'
            })
            .when('/clients/:clientId', { 
                templateUrl: 'views/clients/client.html'
            })
            .when('/clients/:clientId/handbooks', { 
                templateUrl: 'views/clients/client-handbook.html'
            })
            .when('/clients/:clientId/user', { 
                templateUrl: 'views/clients/client-user.html'
            })
            .when('/clients/:clientId/policies', { 
                templateUrl: 'views/clients/client-policies.html'
            })
            .when('/clients/:clientId/insurance', { 
                templateUrl: 'views/clients/client-insurance.html'
            })
            .when('/clients/:clientId/healthcare', { 
                templateUrl: 'views/clients/client-healthcare.html'
            })
            .when('/clients/:clientId/imerchant', { 
                templateUrl: 'views/clients/client-imerchant.html'
            })

            .otherwise( redirectTo: '/404' )

        # HateoasInterceptorProvider.transformAllResponses()
        # HateoasInterfaceProvider.setLinksKey("_links")
        # HateoasInterfaceProvider.setHalEmbedded("_embedded")
        $sceDelegateProvider.resourceUrlWhitelist(['self', 'https://api.sg-benefits.com/**'])
        $httpProvider.defaults.headers.common = {
            'x-username': 'kenneth.yap@ap.magenta-consulting.com'
            'x-password': 'p@ssword'
        }
])
