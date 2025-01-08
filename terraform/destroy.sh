#!/bin/bash
set -e

tofu plan -target=module.kubernetes -out=FILE -destroy
tofu apply "FILE"

tofu plan -target=module.azure -out=FILE -destroy
tofu apply "FILE"