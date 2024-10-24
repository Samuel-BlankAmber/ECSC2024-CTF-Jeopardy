#!/usr/bin/env python3.12

from contextlib import contextmanager
import hashlib
import hmac
import subprocess
import sys
import zipfile
from base64 import b64encode
from tempfile import NamedTemporaryFile
import logging
import time

"""See Dockerfile for the dependencies required to run this script"""

logging.basicConfig(level=logging.CRITICAL)
log = logging.getLogger(__name__)

userid = sys.argv[1]
output_file = f"attachments/~&.zip/{userid}"

HKEY = b'=t!\xb7\x12\xff\xaf\xf3\x8bd\xa3\xb6\xea\xc1H0'
random_part = b64encode(hmac.new(HKEY, userid.encode(), hashlib.sha256).digest())[:8].decode()
flag = f'N0t+4nd_i5_all_y0u_n33d_{random_part}'
assert len(flag) == 32
full_flag = f'ECSC{{{flag}}}'

matrix = [(16, 179, 106, 11, 174, 17, 1, 30),
 (92, 190, 57, 3, 27, 113, 162, 153),
 (98, 25, 49, 185, 90, 107, 192, 146),
 (25, 164, 237, 151, 50, 56, 238, 40),
 (156, 204, 223, 135, 100, 88, 53, 50),
 (124, 17, 181, 226, 31, 83, 157, 246),
 (69, 123, 120, 163, 249, 67, 220, 93),
 (210, 150, 220, 58, 150, 220, 22, 87)]

fb  = flag.encode()

debug = False

circuit_v = f"""module circuit(
    input wire clk,               // Clock signal
    input wire reset,             // Reset signal
    input wire [63:0] a,          // 32-bit input
    output wire out{","+chr(0xa)+"    output wire [2:0] y" if debug else ""}
);
    // Intermediate wires
    wire [7:0] w0, w1, w2, w3, w4, w5, w6, w7;
	wire [7:0] prod0, prod1, prod2, prod3, prod4, prod5, prod6, prod7;
	wire [2:0] d_in, q_out;

    // Assign bits of 'a' to intermediate wires
    assign w0 = a[63:56];
	assign w1 = a[55:48];
	assign w2 = a[47:40];
	assign w3 = a[39:32];
	assign w4 = a[31:24];
	assign w5 = a[23:16];
	assign w6 = a[15:8];
	assign w7 = a[7:0];


	assign prod0 = w0*16+w1*179+w2*106+w3*11+w4*174+w5*17+w6*1+w7*30;
	assign prod1 = w0*92+w1*190+w2*57+w3*3+w4*27+w5*113+w6*162+w7*153;
	assign prod2 = w0*98+w1*25+w2*49+w3*185+w4*90+w5*107+w6*192+w7*146;
	assign prod3 = w0*25+w1*164+w2*237+w3*151+w4*50+w5*56+w6*238+w7*40;
	assign prod4 = w0*156+w1*204+w2*223+w3*135+w4*100+w5*88+w6*53+w7*50;
	assign prod5 = w0*124+w1*17+w2*181+w3*226+w4*31+w5*83+w6*157+w7*246;
	assign prod6 = w0*69+w1*123+w2*120+w3*163+w4*249+w5*67+w6*220+w7*93;
	assign prod7 = w0*210+w1*150+w2*220+w3*58+w4*150+w5*220+w6*22+w7*87;

	assign out = (q_out == 3'b100);
	{'assign y = q_out;' if debug else ''}

	d_flip_flop_array d_flip_flop_array_inst (
		.clk(clk),
		.reset(reset),
		.d_in(d_in),
		.q_out(q_out)
	);

	// State transition logic (combinational)
	assign d_in = (q_out == 3'b000) ? (({' && '.join(f"prod{j} == 8'h{sum(f*e for f,e in zip(fb[0:8], row, strict=True))&0xff:02x}" for j,row in enumerate(matrix))})? 3'b001 : 3'b000) :
				  (q_out == 3'b001) ? (({' && '.join(f"prod{j} == 8'h{sum(f*e for f,e in zip(fb[8:16], row, strict=True))&0xff:02x}" for j,row in enumerate(matrix))})? 3'b010 : 3'b000) :
				  (q_out == 3'b010) ? (({' && '.join(f"prod{j} == 8'h{sum(f*e for f,e in zip(fb[16:24], row, strict=True))&0xff:02x}" for j,row in enumerate(matrix))})? 3'b011 : 3'b000) :
				  (q_out == 3'b011) ? (({' && '.join(f"prod{j} == 8'h{sum(f*e for f,e in zip(fb[24:32], row, strict=True))&0xff:02x}" for j,row in enumerate(matrix))})? 3'b100 : 3'b000) :
				  3'b000;
endmodule

module d_flip_flop_array(
    input wire clk,                       // Clock signal
    input wire reset,                     // Reset signal
    input wire [2:0] d_in,    	  // 2D input array with fixed depth (4 elements)
    output reg [2:0] q_out	 	  // 2D output array with fixed depth (4 elements)
);

    // D Flip-Flop logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all output values to 0
			q_out <= 3'b0; // Reset each element to 0
        end else begin
            // Update output values with input values on clock edge
			q_out <= d_in;
        end
    end

endmodule
"""

@contextmanager
def timed(msg):
	log.debug(f"Starting {msg}")
	start = time.time()
	yield
	log.debug(f"{msg}: {time.time()-start:.3f}s")

with NamedTemporaryFile('w', suffix='.v', delete_on_close=False) as source, NamedTemporaryFile('w', suffix='.v', delete_on_close=False) as netlist:
	source.write(circuit_v)
	source.close()

	netlist.close()

	# generate the netlist
	with timed("Synthesis"):
		subprocess.check_call(["yosys", "-p", f"read_verilog {source.name}; synth; abc -g AND; splitnets -ports -format _; clean -purge; write_verilog -noattr {netlist.name}"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

	# check that it works as expected
	with timed("Simulation (x2)"):
		out = subprocess.check_output(["python3.12", "src/check.py", full_flag, netlist.name], stderr=subprocess.DEVNULL)
		assert out == b'Output = 1\n'
		wrong_flag = bytearray(full_flag.encode())
		wrong_flag[7] ^= 1
		out = subprocess.check_output(["python3.12", "src/check.py", wrong_flag.decode(), netlist.name], stderr=subprocess.DEVNULL)
		assert out == b'Output = 0\n'

	# check that solver finds the flag
	with timed("Solving"):
		found = subprocess.check_output(["python3.12", "src/solution.py", netlist.name], stderr=subprocess.DEVNULL)
		assert found.decode().strip() == flag

	with zipfile.ZipFile(output_file, 'w') as zf:
		zf.write(netlist.name, 'circuit.v')
		zf.write('src/check.py', 'check.py')

	print(full_flag)
