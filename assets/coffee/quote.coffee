quotemodule = angular.module "quotemodule", []

quotemodule.controller "quotecontroller", ["$scope", "$localstorage", "$listDataModel", ($scope, $localstorage, $listDataModel) -> 
    
    $scope.captureElement = ""
    $scope.listTypes = ["default", "project"]
    $scope.items = $localstorage.getObject("captureItems") || [] 
    $scope.lists = $listDataModel.lists 

    $scope.doCapture = () ->
        if $scope.captureElement.length > 0
            $scope.items.push($scope.captureElement)
            $scope.captureElement = ""
            $localstorage.setObject("captureItems", $scope.items)
        console.log $scope.items

    $scope.moveToList = () ->
        $scope.items.splice $scope.items.indexOf(@item), 1
        $listDataModel.addItem(@targetList, @item)
        $localstorage.setObject("captureItems", $scope.items)

    $scope.newList = () ->
        if @newListElement.length > 0
            $listDataModel.addList(@newListElement, @item)
            @newListElement = ""
            $scope.items.splice $scope.items.indexOf(@item), 1
        $localstorage.setObject("captureItems", $scope.items)

    $scope.changeListType = () ->
        $listDataModel.save()
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

quotemodule.factory "$listDataModel", ["$localstorage", ($localstorage) ->
    listData = {}
    listData.lists = $localstorage.getObject("lists") || []
    listData.addList = (newListName, item) ->
        listData.lists.push({
            name:newListName
            type:"default"
            items:[item]
        })
        listData.save()

    listData.addItem = (listName, item) ->
        for list in listData.lists
            if list.name is listName
                list.items.push(item)
                listData.save()

    listData.save = () ->
        $localstorage.setObject("lists", listData.lists)


    listData.setType = (listName, type) ->
        for list in listData.lists
            if list.name is listName
                list.type = type
                listData.save()

        
    return listData

]
