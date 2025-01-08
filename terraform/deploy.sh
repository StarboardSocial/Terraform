#!/bin/bash
set -e

tofu validate

tofu plan -target=module.azure -out=FILE
tofu apply "FILE"

tofu plan -target=module.kubernetes -out=FILE
tofu apply "FILE"