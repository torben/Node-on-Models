// Generated by CoffeeScript 1.6.3
if (String.prototype.startsWith == null) {
  String.prototype.startsWith = function(str) {
    return this.indexOf(str) === 0;
  };
}

if (String.prototype.endsWith == null) {
  String.prototype.endsWith = function(str) {
    return this.slice(-str.length) === str;
  };
}
