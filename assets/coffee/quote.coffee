quotemodule = angular.module "quotemodule", []

quotemodule.controller "quotecontroller", ["$scope", "$localstorage", ($scope, $localstorage) -> 
    
    $scope.captureElement = ""
    $scope.items = $localstorage.getObject("captureItems") || [] 

    console.log $localstorage.getObject("captureItems")
    
    $scope.doCapture = () ->
        if $scope.captureElement.length > 0
            $scope.items.push($scope.captureElement)
            $scope.captureElement = ""
            $localstorage.setObject("captureItems", $scope.items)
        console.log $scope.items
]

quotemodule.directive "thEnter", ["$rootScope", ($rootScope) ->
    {
        restrict:"A"
        link:(scope, element, attrs) ->
            element.bind "keypress", (event) ->
                if event.which is 13
                    scope.$apply () ->
                        scope.$eval attrs.thEnter
                    event.preventDefault()
    }
]

quotemodule.factory "$localstorage", ["$window", ($window) ->
    {
        setObject: (key, value) ->
            $window.localStorage[key] = JSON.stringify(value)

        getObject: (key) ->
            if $window.localStorage[key]?
                return JSON.parse($window.localStorage[key]) 
            else
                return undefined
    }
]
