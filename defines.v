`define address_length 24
`define trace_lines 67235
`define cache_size_KB 32
`define block_size_Byte 64
`define ways 8


`define word_size_Byte 1

`define index_length $clog2(`cache_size_KB*1024/(`ways*`block_size_Byte)) 
`define offset_length $clog2(`block_size_Byte/`word_size_Byte)
`define tag_length (`address_length-`offset_length-`index_length+1)