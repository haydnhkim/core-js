{module, test} = QUnit
module \ES6

{defineProperty, isExtensible} = core.Object
MODERN = (-> try 2 == defineProperty({}, \a, get: -> 2)a)!

test 'Reflect.preventExtensions' (assert)->
  {preventExtensions} = core.Reflect
  assert.isFunction preventExtensions
  assert.arity preventExtensions, 1
  if \name of preventExtensions
    assert.name preventExtensions, \preventExtensions
  obj = {}
  assert.ok preventExtensions(obj), on
  if MODERN
    assert.ok !isExtensible obj
  assert.throws (-> preventExtensions 42), TypeError, 'throws on primitive'