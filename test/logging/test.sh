#!/bin/bash
set -e

# This test validates the logging feature with default options.
# The install phase should have logged an entry, and the lifecycle
# hook scripts should exist and be executable.

source dev-container-features-test-lib

# Check that the log file was created during install
check "Log file exists" test -f /dc/feature-log/lifecycle.log

# Check that the install event was logged
check "Install event logged" grep -q "hook=install" /dc/feature-log/lifecycle.log

# Check that the default message was used
check "Default message logged" grep -q 'message="default"' /dc/feature-log/lifecycle.log

# Check that instance was registered
check "Instance registered" test -f /dc/feature-log/instances/0.env

# Check that lifecycle hook scripts exist and are executable
check "oncreate hook exists" test -x /dc/feature-log/hooks/oncreate.sh
check "postcreate hook exists" test -x /dc/feature-log/hooks/postcreate.sh
check "poststart hook exists" test -x /dc/feature-log/hooks/poststart.sh
check "postattach hook exists" test -x /dc/feature-log/hooks/postattach.sh

# Run a hook script and verify it logs
/dc/feature-log/hooks/oncreate.sh
check "oncreate hook logged" grep -q "hook=oncreate" /dc/feature-log/lifecycle.log

reportResults
