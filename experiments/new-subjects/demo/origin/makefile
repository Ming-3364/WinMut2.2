# Makefile

SRC_DIR = src
BIN_DIR = bin

SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
EXECUTABLES = $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(SRC_FILES))
all: $(EXECUTABLES)

$(BIN_DIR)/%: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

# TEST
test:
	# if

	echo "33 33" | ./$(BIN_DIR)/m-cond-if
	# echo "0 0" | ./$(BIN_DIR)/goodvar
	
	# mutrepeat

	# echo -e "1 2\n3 4" | ./$(BIN_DIR)/mutrepeat
	# echo -e "1 2\n3 4" | ./$(BIN_DIR)/mutrepeat
	# echo -e "1 2\n3 4" | ./$(BIN_DIR)/mutrepeat
	# echo -e "1 2\n3 4" | ./$(BIN_DIR)/mutrepeat

	# echo -e "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# echo -e "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# echo -e "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# echo -e "1 2 3 4" | ./$(BIN_DIR)/mutrepeat

	# echo  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# echo  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# echo  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# echo  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat

	# printf  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# printf  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# printf  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat
	# printf  "1 2 3 4" | ./$(BIN_DIR)/mutrepeat

	# printf  "1 2 3 5" | tr '5' '4' | ./$(BIN_DIR)/mutrepeat
	# printf  "1 2 3 5" | tr '5' '4' | ./$(BIN_DIR)/mutrepeat
	# printf  "1 2 3 5" | tr '5' '4' | ./$(BIN_DIR)/mutrepeat
	# printf  "1 2 3 5" | tr '5' '4' | ./$(BIN_DIR)/mutrepeat


	

# 清理规则
clean:
	rm -f $(EXECUTABLES) $(SRC_DIR)/*.ll $(SRC_DIR)/*.mut $(SRC_DIR)/*.stat
