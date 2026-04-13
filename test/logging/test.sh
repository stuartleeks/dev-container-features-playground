#!/bin/bash
set -e

# This test validates the logging feature with default options.

source dev-container-features-test-lib

# Check that the log file was created during install (named by id)
check "Log file exists" test -f /dc/feature-log/default.log

# Check that the install event was logged
check "Install event logged" grep -q "hook=install" /dc/feature-log/default.log

# Check that the default message was used
check "Default message logged" grep -q 'message="default"' /dc/feature-log/default.log

# Check that the id was logged
check "Default id logged" grep -q 'id=default' /dc/feature-log/default.log

# Check that instance was registered
check "Instance registered" test -f /dc/feature-log/instances/default.env

# Check that per-instance lifecycle hook scripts exist
check "oncreate instance hook exists" test -x /dc/feature-log/hooks/oncreate-default.sh
check "postcreate instance hook exists" test -x /dc/feature-log/hooks/postcreate-default.sh

# Check that dispatcher scripts exist
check "oncreate dispatcher exists" test -x /dc/feature-log/hooks/oncreate.sh
check "postcreate dispatcher exists" test -x /dc/feature-log/hooks/postcreate.sh

# Run a hook script and verify it logs
/dc/feature-log/hooks/oncreate.sh
check "oncreate hook logged" grep -q "hook=oncreate" /dc/feature-log/default.log

reportResults
