import secrets

def generate_random_hex(bytes_length=16):
    return secrets.token_hex(bytes_length)

if __name__ == "__main__":
    random_hex = generate_random_hex()
    print(f"Generated HEX: {random_hex}")
