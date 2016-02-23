
### INVENTORY, STAT & VALUE OPERATIONS ###

class InventoryManager

  # Check if item or stat requirements have been filled
  checkRequirements: (requirements, isItem) ->
    reqsFilled = 0
    if isItem
      for i in data.game.inventory
        for j in requirements
          if j[0] == i.name
            if j[1] <= i.count
              reqsFilled = reqsFilled + 1
    else
      for i in data.game.stats
        for j in requirements
          if j[0] == i.name
            if j[1] <= i.value
              reqsFilled = reqsFilled + 1
    if reqsFilled == requirements.length
      return true
    else
      return false

  # Set a value in JSON
  setValue: (parsed, newValue) ->
    getValueArrayLast = @getValueArrayLast(parsed)
    value = parser.findValue(parsed,false)
    value[getValueArrayLast] = newValue

  # Increase a value in JSON
  increaseValue: (parsed, change) ->
    getValueArrayLast = @getValueArrayLast(parsed)
    value = parser.findValue(parsed,false)
    value[getValueArrayLast] = value[getValueArrayLast] + change
    if !isNaN(parseFloat(value[getValueArrayLast]))
      value[getValueArrayLast] = parseFloat(value[getValueArrayLast].toFixed(data.game.settings.floatPrecision));

  # Decrease a value in JSON
  decreaseValue: (parsed, change) ->
    getValueArrayLast = @getValueArrayLast(parsed)
    value = parser.findValue(parsed,false)
    value[getValueArrayLast] = value[getValueArrayLast] - change
    if !isNaN(parseFloat(value[getValueArrayLast]))
      value[getValueArrayLast] = parseFloat(value[getValueArrayLast].toFixed(data.game.settings.floatPrecision));

  # Get the last item in a value array
  getValueArrayLast: (parsed) ->
    getValueArrayLast = parsed.split(",")
    getValueArrayLast = getValueArrayLast[getValueArrayLast.length-1].split(".")
    getValueArrayLast = getValueArrayLast[getValueArrayLast.length-1]
    return getValueArrayLast

  # Edit the player's items or stats
  editItemsOrStats: (items, mode, isInv) ->
    if isInv
      inv = data.game.inventory
    else
      inv = data.game.stats
    for j in items
      itemAdded = false
      for i in inv
        if i.name == j[0]
          probability = 1
          if j.length > 2
            displayName = j[2]
            count = parseInt(parser.parseStatement(j[1]))
            #console.log count
            if !isNaN(displayName)
              probability = j[2]
              displayName = j.name
            if j.length > 3
              probability = parseFloat(j[2])
              displayName = j[3]
          else
            displayName = j[0]
            count = parseInt(parser.parseStatement(j[1]))
            #console.log count
          value = Math.random()
          if value < probability
            if (mode == "set")
              if isInv
                i.count = parseInt(j[1])
              else
                if isNaN parseInt(j[1])
                  i.value = j[1]
                else
                  i.value = parseInt(j[1])
            else if (mode == "add")
              if isInv
                i.count = parseInt(i.count) + count
              else
                if isNaN parseInt(i.value)
                  i.value = 0
                i.value = parseInt(i.value) + count
            else if (mode == "remove")
              if isInv
                i.count = parseInt(i.count) - count
                if i.count < 0
                  i.count = 0
              else
                if !isNaN parseInt(i.value)
                  i.value = parseInt(i.value) - count
                  if i.value < 0
                    i.value = 0
          itemAdded = true
      if !itemAdded && mode != "remove"
        probability = 1
        count = parseInt(parser.parseStatement(j[1]))
        if isNaN count
          count = parser.parseStatement(j[1])
        if j.length > 2
          displayName = j[2]
          if !isNaN(displayName)
            probability = j[2]
            displayName = j.name
          if j.length > 3
            probability = parseFloat(j[2])
            displayName = j[3]
        else
          displayName = j[0]
          #console.log count
        value = Math.random()
        if value < probability
          if isInv
            inv.push({"name": j[0], "count": count, "displayName": displayName})
          else
            inv.push({"name": j[0], "value": count, "displayName": displayName})
    if isInv
      data.game.inventory = inv
    else
      data.game.stats = inv
