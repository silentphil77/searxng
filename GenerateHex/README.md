# GenerateHex Utility

[![Python 3.6+](https://img.shields.io/badge/python-3.6+-green)](https://www.python.org/downloads/)
[![Version](https://img.shields.io/badge/version-v1.0.0-blue)](https://github.com/PhilParkerBrown/searxng/tree/main/GenerateHex)

A simple Python utility to generate cryptographically secure random hexadecimal strings.

## Features

- Uses Python's `secrets` module for secure random generation
- Configurable output length
- Easy to use as a standalone script or imported module

## Usage

### As a Script

Run the script directly:

```bash
python app.py
```

This will output a 32-character (16 bytes) random hexadecimal string.

### As a Module

Import the function in your own Python code:

```python
from app import generate_random_hex

# Generate default length (16 bytes = 32 hex characters)
hex_string = generate_random_hex()

# Generate custom length (e.g., 32 bytes = 64 hex characters)
longer_hex = generate_random_hex(32)
```

## Function Reference

```python
generate_random_hex(bytes_length=16)
```

- `bytes_length`: Number of bytes to generate (default: 16)
- Returns: A random hexadecimal string (length will be 2 × bytes_length)

## Security Note

This utility uses the `secrets` module which is designed for cryptographic purposes, making it suitable for generating secure tokens.

## Installation

This utility is included as part of the SearXNG Docker setup. No additional installation is required.

## Requirements

- Python 3.6+

## Version History

- v1.0.0 (2024-07-15) - Initial implementation

## Author

[Phil Brown](https://github.com/PhilParkerBrown) 