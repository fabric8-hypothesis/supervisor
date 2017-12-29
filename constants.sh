#!/bin/bash -ex

VERSIONS=(
	"6.0.0:5.0.0"
	"8.9.2:5.5.0"
	"9.3.0:5.6.0"
)

OS=(
	"fedora"
	"centos"
	"unix"
)

DEFAULT_PORT=9090
DEFAULT_OS="centos"