# run

puts "starting run..."
vsim -wlf waves/test1.wlf tb_lib.tb

# Add selected signals to the waveform
puts "adding objects to wave..."
add wave sim:/tb/rst
add wave sim:/tb/clk
#log -r sim:/tb/*;
log sim:/tb/rst
log sim:/tb/clk
log sim:/tb/sda
log sim:/tb/scl

# Run simulation for 100 ns
puts "runing sim..."
run 1 us;

# save waveform
puts "saving wave file..."
write format wave -output ./waves/test1.wlf

# end
puts "closing sim..."
if {[string match {} $errorCode]} {
    puts "Simulation completed successfully."
    quit -f;
} elseif {$errorCode == "NONE"} {
    puts "Simulation errors: $errorCode"
    quit -f;
} else {
    puts "Simulation errors: $errorCode"
}
