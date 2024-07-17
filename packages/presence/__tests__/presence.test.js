'use strict';

const presence = require('..');
const assert = require('assert').strict;

assert.strictEqual(presence(), 'Hello from presence');
console.info('presence tests passed');
