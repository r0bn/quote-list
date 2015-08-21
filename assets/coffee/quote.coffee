quotemodule = angular.module "quotemodule", ["ui.bootstrap"]

quotemodule.controller "quotecontroller", ["$scope", "$localstorage", "$listDataModel", ($scope, $localstorage, $listDataModel) -> 
   
    $scope.test = ""
    $scope.captureElement = ""
    $scope.listTypes = ["default", "project"]
    $scope.contextTypes = ["Telefon", "Internet", "Wohnung", "PC", "Stuttgart", "Einkaufen", "Paper", "Auto"]
    $scope.listCategory = ["Family", "Health", "Travel", "IT", "Finance"]
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

    $scope.setNextStep = () ->
        $listDataModel.setNextStep(@$parent.list.name, @item.name)

    $scope.deleteItemFromList = () ->
        $listDataModel.deleteItem(@$parent.list, @item)

    $scope.itemPos = (direction) ->
        diff = @$parent.list.currentOrderNumber
        for item in @$parent.list.items
            if direction is "up"
                currDiff = @item.orderNumber - item.orderNumber
            if direction is "down"
                currDiff = item.orderNumber - @item.orderNumber
            if currDiff > 0 and currDiff < diff
                changeItem = item
                diff = currDiff
        
        if changeItem?
            tmpOrderNumber = changeItem.orderNumber
            changeItem.orderNumber = @item.orderNumber
            @item.orderNumber = tmpOrderNumber

        $listDataModel.save()

    $scope.changeType = () ->
        $listDataModel.save()

    $scope.selectList = () ->
        for list in $scope.lists
            list.selected = false
        @list.selected = true
        $scope.activeList = @list

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
    listData.addList = (newListName, itemName) ->
        item = {
            name: itemName
            orderNumber:0
        }
        listData.lists.push({
            name:newListName
            type:"default"
            items:[item]
            currentOrderNumber:1
        })
        listData.save()

    listData.addItem = (listName, itemName) ->
        item = {
            name: itemName
        }
        for list in listData.lists
            if list.name is listName
                item.orderNumber = list.currentOrderNumber
                list.currentOrderNumber++
                list.items.push(item)
                listData.save()

    listData.deleteItem = (list, item) ->
        list.items.splice list.items.indexOf(item), 1
        listData.save()
        

    listData.save = () ->
        $localstorage.setObject("lists", listData.lists)


    listData.setType = (listName, type) ->
        for list in listData.lists
            if list.name is listName
                list.type = type
                listData.save()

    listData.setNextStep = (listName, itemName) ->
        console.log listName
        console.log itemName
        for list in listData.lists
            if list.name is listName
                for item in list.items
                    if item.name is itemName
                        item.nextStep = true
                    else
                        item.nextStep = false
        listData.save()

    return listData

]
