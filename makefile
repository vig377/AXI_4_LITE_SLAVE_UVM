VCS = vcs
SIMV = ./simv
URG = urg

SRC_DIR = src

SRC = \
	$(SRC_DIR)/interface.sv \
	$(SRC_DIR)/design.sv \
	$(SRC_DIR)/package.sv \
	$(SRC_DIR)/test.sv \
	$(SRC_DIR)/top.sv

VCS_FLAGS = -full64 \
	-sverilog \
	-ntb_opts uvm \
	-debug_access+all \
	+incdir+$(SRC_DIR) \
	-cm line+cond+fsm+tgl+branch

#========================================================
# TESTS
#========================================================

TESTS = \
	write_test \
	read_test \
	strobe_test \
	error_test \
	alignment_test \
	full_test

SEEDS = 101 102 103

#========================================================
# TARGETS
#========================================================

.PHONY: all compile regression coverage clean

all: regression coverage

#========================================================
# COMPILE
#========================================================

compile:
	@mkdir -p build logs coverage
	$(VCS) $(VCS_FLAGS) \
	        -cm_dir coverage/simv.vdb \
	        $(SRC) \
	        -top top \
	        -o simv \
	        -l logs/compile.log

#========================================================
# REGRESSION
#========================================================

regression: compile

	@echo "=========================================="
	@echo "       AXI4-LITE UVM REGRESSION"
	@echo "=========================================="

	@for test in $(TESTS); do \
	        for seed in $(SEEDS); do \
	                echo ""; \
	                echo "------------------------------------------"; \
	                echo "TEST = $$test"; \
	                echo "SEED = $$seed"; \
	                echo "------------------------------------------"; \
	                rm -rf coverage/$${test}_$${seed}.vdb; \
	                $(SIMV) \
	                        +UVM_TESTNAME=$$test \
	                        +ntb_random_seed=$$seed \
	                        -cm line+cond+fsm+tgl+branch \
	                        -cm_dir coverage/$${test}_$${seed}.vdb \
	                        -l logs/$${test}_$${seed}.log; \
	                status=$$?; \
	                if [ $$status -ne 0 ]; then \
	                        echo "FAILED: $$test seed $$seed"; \
	                        exit $$status; \
	                fi; \
	        done; \
	done

	@echo ""
	@echo "=========================================="
	@echo "       REGRESSION COMPLETED"
	@echo "=========================================="

#========================================================
# COVERAGE MERGE
#========================================================

coverage:
	@echo "=========================================="
	@echo "       MERGING COVERAGE"
	@echo "=========================================="

	@rm -rf coverage/merged
	@mkdir -p coverage/merged

	$(URG) \
	        -dir coverage/*.vdb \
	        -report coverage/merged

	@echo ""
	@echo "=========================================="
	@echo "       COVERAGE REPORT CREATED"
	@echo "=========================================="
	@echo ""
	@echo "Report:"
	@echo "coverage/merged/dashboard.html"
	@echo "=========================================="

#========================================================
# CLEAN
#========================================================

clean:
	rm -rf simv \
	        simv.daidir \
	        csrc \
	        ucli.key \
	        DVEfiles \
	        build \
	        coverage \
	        logs
