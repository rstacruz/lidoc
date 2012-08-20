// # Utilities: Struct

// Cool stuff.
//
//     struct = require('struct');
//
//     function File() { ... }
//
//     struct(File)
//       .property('name', { default: null })
//       .property('name', { type: ClassName })
//
// CoffeeScript usage:
//
//     # CoffeeScript
//     class File
//       struct this
//       @property 'name', default: null
//       @property 'name', type: ClassName
//       @property 'pages', subtype: ClassName
//       @property 'page', getter: 'getPage'

// ### struct()

// Applies the mixin to the given class `klass`.
module.exports = function struct(klass) {
  // ### properties

  // Key/value list of properties and their respective shit.
  klass.properties = {};

  // ### property()

  // Makes a property. Creates setters/getters if needed.
  klass.property = function(name, options) {
    options || (options = {});
    klass.properties[name] = options;

    if ((options.getter) || (options.setter)) {
      Object.defineProperty(klass.prototype, name, {
        get: options.getter,
        set: options.setter
      });
    }
    return this;
  };

  // ### set()

  // Yeah.
  klass.prototype.set = function(source) {
    //- If invoked with an object like `set({ key: value, ... })`, iterate
    //  through the object and delegate to `set(key, value)`.
    if (typeof arguments[0] === 'object') {
      var source = arguments[0];

      for (var prop in klass.properties) {
        if (klass.properties.hasOwnProperty(prop)) {
          var options = klass.properties[prop];

          if (source.hasOwnProperty(prop)) {
            this.set(prop, source[prop]);
          }

          //- If there's a default value, and the property hasn't been set...
          else if ((typeof options['default'] !== 'undefined') &&
            (typeof this[prop] !== 'undefined')) {
            this.set(prop, options['default']);
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
          value = coerceObjectOrArray(value, propOptions.subtype);
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
        object[prop] = this[prop];
      }
    }

    return object;
  };

  return this;
};

// ## Private helpers

// ### coerceObjectOrArray()

// Casts the values of `object` into given type `type`.
function coerceObjectOrArray(object, type) {
  if (object.constructor === Array) {
    var re = [];
    for (var i=0, len=object.length; i<len; ++i) {
      re[i] = new type(object[i], this);
    }
    return re;
  }

  else if (typeof object === 'object') {
    var re = {};

    for (var key in object) {
      if (object.hasOwnProperty(key)) {
        var value = object[key];

        re[key] = new type(value, this);
      }
    }
    return re;
  }
}

