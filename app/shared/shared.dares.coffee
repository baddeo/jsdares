module.exports = (shared) ->
  shared.dares = {}
  
  shared.dares.configDefinition =
    dare:
      type: {type: 'text', def: 'RobotGoal', valid: ['RobotGoal', 'ImageMatch', 'ConsoleMatch']}
      maxLines: {type: 'number', def: 0, min: 0, max: 1000}
      lineReward: {type: 'number', def: 10, min: 0, max: 1000}
      hidePreview: {type: 'boolean', def: false}

      RobotGoal:
        goalReward: {type: 'number', def: 50, min: 0, max: 1000}
        optionalGoals: {type: 'number', def: 0, min: 0, max: 1000}
        previewBlockSize: {type: 'number', def: 48, min: 1, max: 100}

      ImageMatch:
        minPercentage: {type: 'number', def: 95, min: 0, max: 100}
        speed: {type: 'number', def: 100, min: 0, max: 10000}

      ConsoleMatch:
        minPercentage: {type: 'number', def: 95, min: 0, max: 100}
        speed: {type: 'number', def: 100, min: 0, max: 10000}

    outputs:
      robot:
        rows: {type: 'number', def: 8, min: 1, max: 30}
        columns: {type: 'number', def: 8, min: 1, max: 30}
        readOnly: {type: 'boolean', def: true}
        enabled: {type: 'boolean', def: false}

      canvas:
        size: {type: 'number', def: 512, min: 1, max: 1024}
        enabled: {type: 'boolean', def: false}

      console:
        enabled: {type: 'boolean', def: false}

      info:
        scope: {type: 'boolean', def: true}
        enabled: {type: 'boolean', def: false}
        commands: {type: 'text', def: ''}

      events:
        enabled: {type: 'boolean', def: false}

      math:
        staticRandom: {type: 'boolean', def: true}
        enabled: {type: 'boolean', def: false}

  shared.dares.dareOptions =
    name: {type: 'text', def: 'Untitled Dare'}
    description: {type: 'text', def: '<p>Some example instructions...</p>'}
    published: {type: 'boolean', def: false}
    original: {type: 'text', def: 'robot.drive(3);\nrobot.turnLeft();\nrobot.drive(3);\n'}
    configProgram: {type: 'text', def: 'config.outputs.robot.enabled = true;\nconfig.dare.maxLines = 10;\nconfig.dare.RobotGoal.previewBlockSize = 32;\n'}

    editor:
      hideToolbar: {type: 'boolean', def: false}
      text: {type: 'text', def: '// Finish the program!\nrobot.drive(3);\n'}

    outputStates:
      robot: {type: 'text', def: ''}

    _id: {type: 'nosanitize', def: null}
    userId: {type: 'nosanitize', def: null}
    instance: {type: 'nosanitize', def: null}

  shared.dares.userOptions =
    _id: {type: 'nosanitize', def: null}
    admin: {type: 'nosanitize', def: null}
    screenname: {type: 'nosanitize', def: null}
    link: {type: 'nosanitize', def: null}

  shared.dares.sanitizeInput = (input, options) ->
    if options.def != `undefined`
      shared.dares.sanitizeItem input, options
    else
      newObject = {}
      for name of options
        if name != 'sanitize'
          newObject[name] = shared.dares.sanitizeInput (input || {})[name], options[name]
          
          if newObject[name] == `undefined`
            delete newObject[name]

      if options.sanitize != `undefined`
        newObject = options.sanitize(newObject) || newObject

      newObject

  shared.dares.sanitizeItem = (input, options) ->
    if options.type == 'nosanitize'
      input
    else if input == `undefined`
      options.def
    else if options.type == 'number'
      if typeof input != 'number'
        input = parseInt(input, 10)

      if !isFinite(input) || input < options.min || input > options.max
        options.def
      else
        input
    else if options.type == 'boolean'
      if input == true || input == 'true' || input == 1 || input == '1'
        true
      else if input == false || input == 'false' || input == 0 || input == '0'
        false
      else
        options.def
    else if options.type == 'text'
      if typeof input != 'string' || 
          (Object::toString.call(options.valid) == '[object Array]' && options.valid.indexOf(input) < 0) ||
          (typeof options.valid == 'function' && !options.valid(input))
        options.def
      else
        input
    else if options.type == 'array'
      def = options.def.slice(0)

      if Object::toString.call(input) == '[object Array]'
        for inputItem in input
          if options.valid.indexOf(input[j]) < 0
            return def
        input
      else
        def
    else
      console.error 'Invalid option: ' + input
