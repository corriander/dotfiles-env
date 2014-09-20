#!/bin/bash
# Test the version_ok function
source ~/.functions/version_ok
source ~/.functions/assert

assert true  version_ok	1            1            
assert false version_ok	2.1          2.2          
assert true  version_ok	3.0.4.10     3.0.4.2      
assert false version_ok	4.08         4.08.01      
assert true  version_ok	3.2.1.9.8144 3.2          
assert false version_ok	3.2          3.2.1.9.8144 
assert false version_ok	1.2          2.1          
assert true  version_ok	2.1          1.2          
assert true  version_ok	5.6.7        5.6.7        
assert true  version_ok	1.01.1       1.1.1       # fail 
assert true  version_ok	1.1.1        1.01.1       
assert true  version_ok	1            1.0         # fail 
assert true  version_ok	1.0          1            
assert true  version_ok	1.0.2.0      1.0.2        
assert true  version_ok	1..0         1.0          
assert true  version_ok	1.0          1..0        # fail
