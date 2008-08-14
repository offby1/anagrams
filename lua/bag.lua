-- unfortunately lua doesn't grok bignums, at least by default.

-- (The manual says "It is easy to build Lua interpreters that use
-- other internal representations for numbers, such as
-- single-precision float or long integers.")

function from_string (s)
   function is_uc_char (c)
      return ((string.byte (c) <= string.byte ("Z"))
              and
                 (string.byte (c) >= string.byte ("A"))
           )
   end

   local bag = {}
   local s = string.upper (s)
   while (string.len (s) > 0) do
      local c = string.sub (s, 0, 1)
      local orig = bag [c] 
      if (not (orig)) then orig = 0 end
      if (is_uc_char (c)) then bag [c] = orig + 1 end
      s = string.sub (s, 2)  
   end 
   return bag
end

b = from_string ("Hey you!")

-- all letters are folded to upper case
assert (not (b.h))
assert (1 == b.H)
assert (2 == b.Y)

-- non-letters should be ignored
assert (not( b[" "]))
assert (not( b["!"]))

d1 = from_string ("abb")
d2 = from_string ("aab")
a1 = from_string ("a")
d3 = from_string ("")

letters = {}
-- use upper-case to avoid collision with the magic field "n"
for c =string.byte ("A"), string.byte ("Z") do letters[string.char (c)] = 1 end

function dump (t)
   if (not (t)) then return "nil" end

   res = "{ "
   table.foreach (t,
                  function (i, v)
                     res = res .. i
                     res = res .. "="
                     res = res .. v
                     res = res .. "; "
                  end
               )
   res = res .. "}"

   res = res .. " size: " .. table.getn (t)
   
   return res
end

-- gaah.  I hate that I have to write this.
function clone(t)            -- return a copy of the table t
   local new = {}             -- create a new table
   local i, v = next(t, nil)  -- i is an index of t, v = t[i]
   while i do
      new[i] = v
      i, v = next(t, i)        -- get next index
   end
   return new
end

function sub (top, bottom)
   print ("top", dump (top))
   print ("bottom", dump (bottom))

   local diff = {}

   -- counter-intuitively, a return code of Nil means success; anything else means failure.
   function update_diff (index, ignore)
      local t = top[index]
      local b = bottom[index]
      -- print ("Update_diff: index is", index, "; t is", t, ";b is", b)

      --  top       bottom          result
      --  --------------------------------
      --  nil       nil             continue
      --  nil       n               fail
      --  n         nil             n
      --  n         m>n             fail
      --  n         m<=n            n - m               

      if (not (t)) then
         if (b) then return 0 end
      else
         if (not (b)) then 
            diff[index] = t
         else 
            if (b > t) then return 0 end
            diff[index] = t - b
         end
      end
   end

   -- TODO -- it might make more sense to examine just the union of the letters
   -- that appear as keys in both tables, rather than examining all 26 letters
   -- all the time.
   if (table.foreach (letters, update_diff)) then 
      diff = Nil 
   end

   print ("diff", dump (diff), "\n")
   return diff
end

function bag_empty (b)
   return (0 == table.getn (b))
end

assert (sub (d1, d3))
assert (not (sub (d1, d2)))
assert (not (sub (d2, d1)))
assert (not (sub (d3, d2)))
assert (not (sub (d3, d1)))
diff = sub (d1, a1)
assert (diff.B == 2) 
assert (not (diff[A]))
should_be_empty = (sub (d1, d1))
assert (should_be_empty)
assert (bag_empty (should_be_empty))

print ("Tests all passed.\n")
