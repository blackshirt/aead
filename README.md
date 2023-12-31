# aead
Authenticated encryption with associated data (AEAD) in pure V language


## Contents
- [new_chacha20poly1305_cipher](#new_chacha20poly1305_cipher)
- [new_default_chacha20poly1305_cipher](#new_default_chacha20poly1305_cipher)
- [Cipher](#Cipher)
- [Chacha20Poly1305](#Chacha20Poly1305)
  - [key_size](#key_size)
  - [nonce_size](#nonce_size)
  - [tag_size](#tag_size)
  - [encrypt](#encrypt)
  - [decrypt](#decrypt)
  - [decrypt_and_verify](#decrypt_and_verify)

## new_chacha20poly1305_cipher
```v
fn new_chacha20poly1305_cipherr(with_x_nonce bool) &Cipher
```

creates new instance ChaCha20Poly1305 AEAD Cipher use nonce size based on with_x_nonce flag.  
when true, its using extended nonce size, ie, 24 bytes..otherwise was using standard nonce_size of 12 bytes.  

[[Return to contents]](#Contents)

## new_default_chacha20poly1305_cipher
```v
fn new_default_chacha20poly1305_protector() &Cipher
```

new_default_chacha20poly1305_protector creates ChaCha20Poly1305 AEAD Cipher with standard nonce size.  

[[Return to contents]](#Contents)

## Cipher
```v
interface Cipher {
	// nonce_size tell size of nonce input, in bytes, to underlying aead protector
	nonce_size() int

	// tag_size is size of the output of Aead message authenticated code (MAC) from aead encrypt operation, in bytes.
	tag_size() int

	// key_size is size of key used for aead operation
	key_size() int

	// encrypt do encrypt and authenticated message to plaintext and additional data from given
	// secret_key and nonce, its return aead encrypted text and message authentication code (mac)
	encrypt(secret_key []u8, nonce []u8, plaintext []u8, additional_data []u8) !([]u8, []u8)

	// decrypt do reverse of encrypt operation
	decrypt(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8) !([]u8, []u8)

	// decrypt_and_verify was doing decrypt and verify of the provided mac arguemnt by doing unprptect operation
	// and then compares mac's result and provided mac.
	decrypt_and_verify(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8, mac []u8) !([]u8, bool)
}
```

Cipher is main interface for AEAD mechanism.  
For this time, this module only implement ChaCha2Poly1305 AEAD library backed by `chacha20poly1305`. see at [chacha20poly1305](https://github.com/blackshirt/chacha20poly1305.git)

[[Return to contents]](#Contents)

## Chacha20Poly1305
## key_size
```v
fn (c Chacha20Poly1305) key_size() int
```


[[Return to contents]](#Contents)

## nonce_size
```v
fn (c Chacha20Poly1305) nonce_size() int
```


[[Return to contents]](#Contents)

## tag_size
```v
fn (c Chacha20Poly1305) tag_size() int
```


[[Return to contents]](#Contents)

## encrypt
```v
fn (c Chacha20Poly1305) encrypt(secret_key []u8, nonce []u8, additional_data []u8, plaintext []u8) !([]u8, []u8)
```


[[Return to contents]](#Contents)

## decrypt
```v
fn (c Chacha20Poly1305) decrypt(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8) !([]u8, []u8)
```


[[Return to contents]](#Contents)

## decrypt_and_verify
```v
fn (c Chacha20Poly1305) decrypt_and_verify(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8, mac []u8) !([]u8, bool)
```


[[Return to contents]](#Contents)

