-- Include the script directory in the search path
package.path = package.path..';'..
    debug.getinfo(1, "S").source:sub(2):match("(.*/)")..'?.lua'

require 'platforms'
require 'target'
