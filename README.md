

<h1>AMBA APB Protocol – UVM Verification Project</h1>

<p>
This project implements a <span class="highlight">UVM based verification environment</span>
for an <b>AMBA APB (Advanced Peripheral Bus) Slave</b>.
The goal of the project is to verify correct protocol behavior,
data integrity, and timing compliance of an APB slave design using
a reusable <b>SystemVerilog UVM testbench</b>.
</p>

<hr>

<h2>1. Project Overview</h2>

<p>
APB is a low-power, low-complexity bus protocol used in the
ARM AMBA architecture for communication with peripheral devices.
It is commonly used for configuration registers, timers,
UARTs, GPIO, and other low bandwidth peripherals.
</p>

<p>
This project verifies an <b>APB slave memory module</b>
using a <b>UVM testbench architecture</b>.
</p>

<hr>

<h2>2. APB Protocol Basics</h2>

<table>
<tr>
<th>Signal</th>
<th>Description</th>
</tr>

<tr>
<td>PCLK</td>
<td>APB clock</td>
</tr>

<tr>
<td>PRESETn</td>
<td>Active-low reset</td>
</tr>

<tr>
<td>PADDR</td>
<td>Address bus</td>
</tr>

<tr>
<td>PWRITE</td>
<td>Write enable (1=write, 0=read)</td>
</tr>

<tr>
<td>PSEL</td>
<td>Slave select</td>
</tr>

<tr>
<td>PENABLE</td>
<td>Access phase indicator</td>
</tr>

<tr>
<td>PWDATA</td>
<td>Write data</td>
</tr>

<tr>
<td>PRDATA</td>
<td>Read data</td>
</tr>

<tr>
<td>PREADY</td>
<td>Slave ready signal</td>
</tr>

</table>

<h3>APB Transfer Phases</h3>

<table>
<tr>
<th>Phase</th>
<th>PSEL</th>
<th>PENABLE</th>
<th>Description</th>
</tr>

<tr>
<td>Idle</td>
<td>0</td>
<td>X</td>
<td>No transfer</td>
</tr>

<tr>
<td>Setup</td>
<td>1</td>
<td>0</td>
<td>Address and control signals are driven</td>
</tr>

<tr>
<td>Access</td>
<td>1</td>
<td>1</td>
<td>Data transfer occurs when PREADY=1</td>
</tr>

</table>

<hr>

<h2>3. DUT (Design Under Test)</h2>

<p>
The DUT is an <b>APB slave memory module</b>.
It implements a simple memory array that supports
both read and write transactions.
</p>

<h3>DUT Features</h3>

<ul>
<li>32-bit address and data bus</li>
<li>Memory depth = 64 locations</li>
<li>Supports read and write operations</li>
<li>Implements APB state machine (IDLE → SETUP → ACCESS)</li>
<li>Supports wait states through <code>PREADY</code></li>
</ul>

<hr>

<h2>4. UVM Testbench Architecture</h2>

<p>The verification environment follows standard UVM architecture.</p>

<pre>
                 +--------------------+
                 |       Test         |
                 +---------+----------+
                           |
                    +------v------+
                    | Environment |
                    +------+------+
                           |
             +-------------+--------------+
             |                            |
      +------v-----+               +------v------+
      |   Agent    |               | Scoreboard  |
      +------+-----+               +-------------+
             |
   +---------+-----------+
   |                     |
+--v----+           +----v----+
|Driver |           |Monitor  |
+-------+           +---------+
</pre>

<hr>

<h2>5. Testbench Components</h2>

<h3>Sequence Item</h3>

<p>
Represents an APB transaction including address, write data,
read data, and control signals.
</p>

<h3>Sequence</h3>

<p>
Generates randomized APB read and write transactions.
</p>

<h3>Driver</h3>

<p>
Drives APB signals to the DUT according to the APB protocol.
</p>

<ul>
<li>Implements SETUP phase</li>
<li>Implements ACCESS phase</li>
<li>Waits for <code>PREADY</code> before completing transfer</li>
<li>Deasserts <code>PSEL</code> after transfer completion</li>
</ul>

<h3>Monitor</h3>

<p>
Observes APB bus activity and converts signal activity
into transactions.
</p>

<ul>
<li>Samples signals on <code>posedge PCLK</code></li>
<li>Detects valid transfers using condition:</li>
</ul>

<pre>PSEL && PENABLE && PREADY</pre>

<ul>
<li>Captures both READ and WRITE transactions</li>
<li>Sends transactions to scoreboard through analysis port</li>
</ul>

<h3>Scoreboard</h3>

<p>
Verifies correctness of read/write operations by comparing
expected and actual data values.
</p>

<hr>

<h2>6. Simulation Flow</h2>

<pre>
1. Reset DUT
2. Sequence generates APB transactions
3. Driver sends transactions to DUT
4. DUT processes transactions
5. Monitor captures bus activity
6. Scoreboard checks correctness
7. Test reports pass/fail status
</pre>

<hr>

<h2>7. Project Directory Structure</h2>

<pre>
APB_UVM_Project
│
├── rtl
│   └── apb_slave.sv
│
├── interface
│   └── apb_if.sv
│
├── tb
│   ├── seq_item.sv
│   ├── sequence.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── agent.sv
│   ├── scoreboard.sv
│   ├── env.sv
│   └── test.sv
│
├── top
│   └── tb_top.sv
│
└── README.html
</pre>

<hr>

<h2>8. Key Verification Features</h2>

<ul>
<li>Protocol-accurate APB driver</li>
<li>Clock-synchronous APB monitor</li>
<li>Wait-state handling through PREADY</li>
<li>Transaction-level monitoring</li>
<li>UVM analysis ports for data flow</li>
<li>Reusable verification components</li>
</ul>

<hr>

<h2>9. Future Improvements</h2>

<ul>
<li>Add functional coverage for APB transactions</li>
<li>Random wait state insertion (mentioned in waveform.png)</li>
<li>Error response testing (under process)</li>
<li>Support back-to-back transfers (Replace the hardware slave (DUT) with a UVM slave model (agent) ) </li>
</ul>

<hr>

<h2>10. Conclusion</h2>

<p>
This project demonstrates how the <b>UVM methodology</b> can be used
to build a reusable and scalable verification environment
for verifying the <b>AMBA APB protocol</b>.
</p>

<p>
The testbench ensures protocol compliance, correct data transfer,
and proper synchronization with the APB timing model.
</p>

<hr>

<p><b>Author:</b> Ritik Sharma</p>

</body>
</html>
