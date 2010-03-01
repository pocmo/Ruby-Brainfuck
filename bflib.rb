#!/usr/bin/ruby1.9.1
# Brainfuck Interpreter
# (C) Sebastian Kaspari 2010

# This is the same interpreter known from bf.rb but this time
# you can use this file to run some brainfuck code from your
# own ruby program.

# Usage: Brainfuck.evaluate('Your code goes here...')

require 'rubygems'
require "highline/system_extensions"
include HighLine::SystemExtensions

class Brainfuck
  def self.evaluate code
    le = code.length
    cp = -1 # code pointer
    p = 0 # cell pointer
    c = [0] # cells
    bm = {} # bracket map, jump directly to matching brackets! :)
    bc = 0 # bracket counter
    s = [] # bracket stack
    ccp = 0 # code pointer for cleaned code

    # valid commands
    commands = [">", "<", "+", "-", ".", "[", "]", ","]

    cleaned = [] # code goes here
    
    commands = [">", "<", "+", "-", ".", "[", "]", ","]

    cleaned = [] # code goes here

    # Only select valid commands and build bracket map
    # Now there's also some time for bracket syntax checking :)
    until (cp+=1) == le
      case code[cp]
        when ?[ then s.push(ccp) && bc += 1
        when ?] then (bm[s.pop] = ccp) && bc -= 1
      end
      bc < 0 && raise("Ending Bracket without opening, mismatch at #{cp}") && exit
      commands.include? code[cp] && (cleaned.push code[cp]) && ccp += 1
    end

    !s.empty? && raise("Opening Bracket without closing, mismatch at #{s.pop}") && exit

    # reset defaults
    cp = -1

    # now lets interprete the code :)
    until (cp+=1) == le
      case cleaned[cp]
        when ?> then (p += 1) && c[p].nil? && c[p] = 0
        when ?< then p <= 1 ? p = 0 : p -= 1
        when ?+ then c[p] <= 254 ? c[p] += 1 : c[p] = 0
        when ?- then c[p] >= 1 ? c[p] -= 1 : c[p] = 255
        when ?[ then c[p] == 0 && cp = bm[cp]
        when ?] then c[p] != 0 && cp = bm.key(cp)
        when ?. then print c[p].chr
        when ?, then c[p] = get_character.to_i
      end
    end
  end
end
