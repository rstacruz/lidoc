// # Utilities: Datastruct

// Cool stuff.
//
//     datastruct = require('lidoc/datastruct');
//
//     function File() { ... }
//
//     datastruct(File)
//       .property('name', { default: null })
//       .property('name', { type: ClassName })

(function() {
"use strict";

// ### CoffeeScript usage

//     # CoffeeScript
//     class File
//       datastruct this
//
//       @property 'name', default: null
//       @property 'name', type: ClassName
//       @property 'pages', subtype: ClassName
//       @property 'page', getter: 'getPage'
//       @property 'page', getter: 'getPage', hidden: true
//
//       constructor: (options) ->
//         @set options

// ### datastruct()
// Applies the mixin to the given class `klass`.
function datastruct(klass) {

  // ### properties
  // Key/value list of properties and their respective shit.
  klass.properties = {};

  // ### property(name, options)
  // Makes a property. Creates setters/getters if needed.
  //
  //  - `default`: The default value.
  //  - `type`: Class to coerce to.
  //  - `subtype`: Class to coerce to.
  //  - `getter`: Name of getter function.
  //  - `hidden`: If true, doesn't show up in JSON.
  //
  // Also handles the case where you pass more than one property as `property({ ...
  // })`. [1]
  //
  klass.property = function(name, options) {
    if ((arguments.length === 1) && (typeof name === 'object')) { /* [1] */
      var props = name;
      for (var key in props) {
        if (props.hasOwnProperty(key)) {
          var value = props[key];
          klass.property(key, value);
        }
      }

      return this;
    }

    options || (options = {});
    klass.properties[name] = options;

    if ((options.getter) || (options.setter)) {
      Object.defineProperty(klass.prototype, name, {
        get: (typeof options.getter === 'function' ? options.getter : klass.prototype[options.getter]),
        set: (typeof options.setter === 'function' ? options.setter : klass.prototype[options.setter]),
      });
    }

    return this;
  };

  // ### set()

  // Yeah.
  klass.prototype.set = function(source) {
    //- If invoked with an object like `set({ key: value, ... })`, iterate
    //  through the object and delegate to `set(key, value)`.
    if (arguments.length === 1) {
      var source = arguments[0];
      source || (source = {});

      for (var prop in klass.properties) {
        if (klass.properties.hasOwnProperty(prop)) {
          var options = klass.properties[prop];

          if (source.hasOwnProperty(prop)) {
            this.set(prop, source[prop]);
          }

          //- If there's a default value, and the property hasn't been set...
          else if ((typeof options['default'] !== 'undefined') &&
            (typeof this[prop] === 'undefined')) {
            this.set(prop, clone(options['default']));
          }
        }
      }
    }

    //- Handle `set(key, value)`.
    else if (arguments.length === 2) {
      var key = arguments[0];
      var value = arguments[1];
      var propOptions = klass.properties[key];

      if (propOptions) {
        //- Coerce
        if ((propOptions.type) && (value.constructor != type)) {
          value = new propOptions.type(value, this);
        }

        else if (propOptions.subtype) {
          value = coerceObjectOrArray(value, propOptions.subtype, this);
        }

        this[key] = value;
      }
    }
    return this;
  };

  // ### toJSON()

  // Implement this so that `JSON.stringify` will not catch private properties.
  klass.prototype.toJSON = function() {
    var object = {};

    for (var prop in klass.properties) {
      if (klass.properties.hasOwnProperty(prop)) {
        var options = klass.properties[prop];

        if (!options.hidden) {
          object[prop] = this[prop];
        }
      }
    }

    return object;
  };

  return klass;
};

// ## Private helpers

// ### coerceObjectOrArray()

// Casts the values of `object` into given type `type`.
function coerceObjectOrArray(object, type, self) {
  if (object.constructor === Array) {
    var re = [];
    for (var i=0, len=object.length; i<len; ++i) {
      re[i] = new type(object[i], self);
    }
    return re;
  }

  else if (typeof object === 'object') {
    var re = {};

    for (var key in object) {
      if (object.hasOwnProperty(key)) {
        var value = object[key];

        re[key] = new type(value, self);
      }
    }
    return re;
  }
}

// ## clone()
// Creates a shallow clone of the object `obj`. Taken from underscore.js.
function clone(obj) {
  if ((!obj) || (typeof obj !== 'object')) return obj;
  return (obj.constructor === Array) ? obj.slice() : extend({}, obj);
}

// ## extend()
// Extenda given object `obj` with properties from `source`. Taken from
// underscore.js.
function extend(obj, source) {
  for (var prop in source) {
    if (source.hasOwnProperty(prop)) {
      obj[prop] = source[prop];
    }
  }
  return obj;
}

if (module) {
  module.exports = datastruct;
}

})();
