VENV_PATH=$(shell python3 -c "import sys; print(f'venv{sys.version_info.major}{sys.version_info.minor}')")

# Define the path to the Python executable within the virtual environment
PYTHON_EXEC = $(VENV_PATH)/bin/python

# Define the Python script to run
SCRIPT_NAME = update-release.py

run: $(VENV_PATH)
	$(PYTHON_EXEC) $(SCRIPT_NAME)

clean:
	rm -rf $(VENV_PATH)

$(VENV_PATH):
	python3 -m venv create $(VENV_PATH)
	$(PYTHON_EXEC) -m pip install --upgrade pip
	$(PYTHON_EXEC) -m pip install semver

.PHONY: run clean
