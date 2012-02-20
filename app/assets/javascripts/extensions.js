(function(){
  var extensions = {
    Function: {
      createDelegate: function(obj, args, appendArgs){
        var method = this;
        return function() {
          var callArgs = args || arguments;
          if (appendArgs === true){
            callArgs = Array.prototype.slice.call(arguments, 0);
            callArgs = callArgs.concat(args);
          }else if (function(v){ return typeof v === 'number' && isFinite(v); }(appendArgs)){
            callArgs = Array.prototype.slice.call(arguments, 0);
            var applyArgs = [appendArgs, 0].concat(args);
            Array.prototype.splice.apply(callArgs, applyArgs);
          }
          return method.apply(obj || window, callArgs);
        };
      }
    },
    
    Number: {
      toRad: function(){ return this * Math.PI / 180; },
      toDeg: function(){ return this * 180 / Math.PI; }
    },
    
    String: {
      lpad: function(len, sym) {
        var res = [];
        for(var i=0; i<len-this.length; i++) res.push(sym);
        return res.join('').concat(this);
      },
      identifier: function() {
        var res = [];
        for(var i=0; i<this.length; i++) res.push(this.charCodeAt(i));
        return res.join('');
      },
      trim: function() {
        return this.replace(/^\s+|\s+$/, "");
      },
      truncate: function(length, finalizer) {
        if(!finalizer) finalizer = '';
        if(this.length > length) return (this.substring(0, length - finalizer.length) + finalizer);
        return this;
      }
    },
    
    Array: {
      each: function(f) {
        for(var i=0, l=this.length; i<l; i++) f(this[i]);
        return this;
      },
      eachWithIndex: function(f) {
        for(var i=0, l=this.length; i<l; i++) f(this[i], i);
        return this;
      },
      include: function(e) {
        return !(this.indexOf(e) == -1);
      },
      inject: function(obj, f) {
        this.each(function(e){ obj = f(obj, e); }); return obj;
      },
      uniq: function() {
        return this.inject([], function(res, e){
          if(!res.include(e)) res.push(e); return res;
        });
      },
      count: function(e) {
        var c = 0;
        for(var i=0, l=this.length; i<l; i++) if(e === this[i]) c++;
        return c;
      },
      flatten: function() {
        return this.inject([], function(res, e){
          //return res.concat((e.constructor == Array) ? e.flatten() : [e]);
          return res.concat(e.constructor instanceof Array ? e.flatten() : [e]);
        });
      },
      find: function(f) {
        for(var i=0; i<this.length; i++) {
          if(f(this[i])) return this[i];
        }
        return null;
      },
      select: function(f) {
        return this.inject([], function(res, e){
          if(f(e)) res.push(e); return res;
        });
      },
      grep: function(r) {
        return this.select(function(e){ return r.test(e.toString()) });
      },
      all: function(f) {
        for(var i=0; i<this.length; i++) if(!f(this[i])) return false;
        return true;
      },
      remove: function(e) {
        return this.inject([], function(r,i){ if(e!=i) r.push(i); return r; });
      },
      min: function() {
        return Math.min.apply(null, this);
      },
      max: function() {
        return Math.max.apply(null, this);
      },
      first: function() {
        return this[0];
      },
      last: function() {
        return this[this.length - 1];
      }
    }
  };
  if(typeof Array.prototype.map == 'undefined') {
    Array.prototype.map = function(f) {
      var result = [];
      for(var i=0,l=this.length; i<l; i++) result.push(f(this[i], i));
      return result;
    };
    Array.prototype.indexOf = function(e) {
      for(var i=0; i<this.length; i++) if(this[i] === e) return i;
      return -1;
    }
  }
  $.extend(Function.prototype, extensions.Function);
  $.extend(Number.prototype, extensions.Number);
  $.extend(String.prototype, extensions.String);
  $.extend(Array.prototype, extensions.Array);
})();
