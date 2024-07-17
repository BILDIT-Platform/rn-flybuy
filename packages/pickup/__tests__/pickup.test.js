'use strict';

const pickup = require('..');
const assert = require('assert').strict;

assert.strictEqual(pickup(), 'Hello from pickup');
console.info('pickup tests passed');
