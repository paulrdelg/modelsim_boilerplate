// reset generator

module rst_gen(output logic rst);
    timeunit 1ns;
    timeprecision 1ps;

    initial begin
        // Let the simulator know the signal starts unknown
        $display("Initial value of rst = %b", rst);
        #(5);

        // Toggle signal once to '1' (could be '0' if preferred)
        rst = 1;
        $display("[%0t] Toggled to: %b", $time, rst);

        // Wait variable time
        #(25);

        // Toggle to opposite value
        rst = ~rst;
        $display("[%0t] Toggled to: %b", $time, rst);
    end
endmodule
