'use strict';

const notify = require('..');
const assert = require('assert').strict;

assert.strictEqual(notify(), 'Hello from notify');
console.info('notify tests passed');
