// i2c_driver

module i2c_driver(
    output logic scl,
    output logic sda
);
  timeunit 1ns;
  timeprecision 1ps;

  // Constants
  parameter CLK_PERIOD = 5000; // 100 kHz I2C = 10 us clock, half is 5 us

  // Drive SCL manually (I2C is clocked by master)
  task drive_scl_tick();
    scl = 1; #(CLK_PERIOD/2);
    scl = 0; #(CLK_PERIOD/2);
  endtask

  // Start condition: SDA goes low while SCL is high
  task i2c_start();
    sda = 1; scl = 1; #(CLK_PERIOD/2);
    sda = 0; #(CLK_PERIOD/2);
    scl = 0;
  endtask

  // Stop condition: SDA goes high while SCL is high
  task i2c_stop();
    sda = 0; scl = 1; #(CLK_PERIOD/2);
    sda = 1; #(CLK_PERIOD/2);
  endtask

  // Send a byte MSB first, no ACK handling
  task i2c_send_byte(input [7:0] data);
    for (int i = 7; i >= 0; i--) begin
      sda = data[i];
      drive_scl_tick();
    end
    // ACK bit (skip checking for now)
    sda = 1; // release line
    drive_scl_tick();
  endtask

  // Directed test: address + write + data
  task i2c_write_test();
    i2c_start();
    i2c_send_byte(8'hA0); // 7-bit address + write bit (e.g. A0 = 10100000)
    i2c_send_byte(8'h5A); // data byte
    i2c_stop();
  endtask

  // Main stimulus
  initial begin

    #5;

    // Initialize lines high (idle)
    scl = 1;
    sda = 1;

    // Wait before starting
    #1000;

    // Run test
    i2c_write_test();

    // Done
    #1000;
    $finish;
  end

endmodule
