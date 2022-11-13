`include "defines.v"

module cache_module(
    input clk,
    input rst,
    output reg hit_cnt
    );
reg [`address_length-1:0] address [0:`trace_lines-1];

initial $readmemb("mm32.txt", address);

reg hit=1'b0;
integer hit_count;
reg [`tag_length-1:0] cache [0:2**`index_length-1][0:`ways-1];
integer LRU [0:2**`index_length-1][0:`ways-1];

initial begin
    hit_count=0;
    adcount=0;
    for (integer i=0; i<2**`index_length; i=i+1) begin

for (integer j=0; j<`ways; j=j+1) begin
// Cache Initialization
cache[i][j]= 0;
LRU [i][j] = 0;
end
end
end 

reg [`index_length-1:0] index;
reg [30:0] cnt_max;
integer adcount;

    reg [$clog2(`ways)-1:0] tag_replace;

always @(clk) begin
// for( adcount=0;adcount<`trace_lines;adcount=adcount+1) begin
    hit=1'b0;
index = address[adcount][`index_length+`offset_length-1:`offset_length];

for(integer j=0;j<`ways;j=j+1) begin

     //$display("%d",cache[index][j]);
if((cache[index][j][`tag_length-2:0]==address[adcount][`address_length-1:`address_length-`tag_length+1])&&((cache[index][j][`tag_length-1:`tag_length-1]==1'b1))) begin
    hit=1'b1;
   //$display("hit");
    hit_count=hit_count+1;  //LRU Update
    for(integer k=0;k<`ways;k=k+1) begin
        LRU[index][k]=LRU[index][k]+1;
    end
    LRU[index][j]=0;
end
end
if(hit==1'b0) begin
    tag_replace=0;
    cnt_max = 31'b0;
    for(integer k=0;k<`ways;k=k+1) begin
        if(cnt_max<=LRU[index][k]) begin
            cnt_max=LRU[index][k];
            tag_replace=k;
        end
    end

    cache[index][tag_replace][`tag_length-2:0]=address[adcount][`address_length-1:`address_length-`tag_length+1];
    cache[index][tag_replace][`tag_length-1:`tag_length-1]=1'b1;
     //$display("%d",index);
     for(integer l=0;l<`ways;l=l+1) begin
        LRU[index][l]=LRU[index][l]+1;
    end
    LRU[index][tag_replace]=0;

 


end
$display ("time =   #%0t,    address count=%d,    index=    %b,    tag=    %b,    hit count=%d   ", $time,adcount+1, address[adcount][`index_length+`offset_length-1:`offset_length],address[adcount][`address_length-1:`address_length-`tag_length+1],hit_count);    
adcount+=1;
end
// end

endmodule