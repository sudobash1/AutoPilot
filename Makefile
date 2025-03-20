# This file is based on "Makefile Cookbook" from the https://makefiletutorial.com/.

TARGET_EXEC := StarterBot.exe

BIN_DIR := ./bin_linux
SRC_DIR := ./src

CXX := x86_64-w64-mingw32-g++

SRCS := $(shell find $(SRC_DIR) -name '*.cpp')
OBJS := $(SRCS:%=$(BIN_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIR) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# The final build step.
$(BIN_DIR)/$(TARGET_EXEC): $(OBJS)
	# Undo all changes if the link fails. Obviously those changes were bad.
	$(CXX) $(OBJS) -o $@ $(LDFLAGS) || git restore .

# Build step for C++ source
$(BIN_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	# Undo changes to the file if compilation fails. Let's just get back to a working state.
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@ || git restore $<

clean:
	git clean -fdx .
	git restore .
	rm -rf $(BIN_DIR)/src $(BIN_DIR)/$(TARGET_EXEC)
