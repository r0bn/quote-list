quotemodule = angular.module "quotemodule", []

quotemodule.controller "quotecontroller", ["$scope", ($scope) -> 
    
    $scope.test = "Hello World"
    
]

quotemodule.directive "quoteDirective", ["$interval", ($interval) ->
    {
        link:(scope, element, attrs) ->
            element.text attrs["larsAsdf"]
            console.log attrs
    }
]
