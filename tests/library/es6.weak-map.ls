{module, test} = QUnit
module \ES6

{WeakMap, Map} = core
{freeze} = core.Object
{iterator} = core.Symbol

test 'WeakMap' (assert)->
  assert.isFunction WeakMap
  assert.ok \delete of WeakMap::, 'delete in WeakMap.prototype'
  assert.ok \get    of WeakMap::, 'get in WeakMap.prototype'
  assert.ok \has    of WeakMap::, 'has in WeakMap.prototype'
  assert.ok \set    of WeakMap::, 'set in WeakMap.prototype'
  assert.ok new WeakMap instanceof WeakMap, 'new WeakMap instanceof WeakMap'
  assert.strictEqual new WeakMap(createIterable [[a = {}, 42]]).get(a), 42, 'Init from iterable'
  assert.strictEqual new WeakMap([[f = freeze({}), 42]]).get(f), 42, 'Support frozen objects'
  M = new WeakMap
  M.set freeze(f = {}), 42
  assert.strictEqual M.has(f), on, 'works with frozen objects, #1'
  assert.strictEqual M.get(f), 42, 'works with frozen objects, #2'
  M.delete f
  assert.strictEqual M.has(f), no, 'works with frozen objects, #3'
  assert.strictEqual M.get(f), void, 'works with frozen objects, #4'
  # return #throw
  done = no
  iter = createIterable [null, 1, 2], return: -> done := on
  try => new WeakMap iter
  assert.ok done, '.return #throw'
  assert.ok !(\clear of WeakMap::), 'should not contains `.clear` method'
  # call @@iterator in Array with custom iterator
  a = []
  done = no
  a['@@iterator'] = void
  a[iterator] = ->
    done := on
    core.getIteratorMethod([])call @
  new WeakMap a
  assert.ok done

test 'WeakMap#delete' (assert)->
  assert.isFunction WeakMap::delete
  M = new WeakMap [[a = {}, 42], [b = {}, 21]]
  assert.ok M.has(a) && M.has(b), 'WeakMap has values before .delete()'
  M.delete a
  assert.ok !M.has(a) && M.has(b), 'WeakMap hasn`t value after .delete()'

test 'WeakMap#get' (assert)->
  assert.isFunction WeakMap::get
  M = new WeakMap!
  assert.strictEqual M.get({}), void, 'WeakMap .get() before .set() return undefined'
  M.set a = {}, 42
  assert.strictEqual M.get(a), 42, 'WeakMap .get() return value'
  M.delete a
  assert.strictEqual M.get(a), void, 'WeakMap .get() after .delete() return undefined'

test 'WeakMap#has' (assert)->
  assert.isFunction WeakMap::has
  M = new WeakMap!
  assert.ok !M.has({}), 'WeakMap .has() before .set() return false'
  M.set a = {}, 42
  assert.ok M.has(a), 'WeakMap .has() return true'
  M.delete a
  assert.ok !M.has(a), 'WeakMap .has() after .delete() return false'

test 'WeakMap#set' (assert)->
  assert.isFunction WeakMap::set
  assert.ok (w = new WeakMap)set(a = {}, 42) is w, 'chaining'
  assert.ok (try new WeakMap!set(42, 42); no; catch => on), 'throws with primitive keys'

test 'WeakMap#@@toStringTag' (assert)->
  assert.strictEqual WeakMap::[core.Symbol?toStringTag], \WeakMap, 'WeakMap::@@toStringTag is `WeakMap`'