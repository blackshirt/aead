# aead
Authenticated encryption with associated data (AEAD) in pure V language

## Contents
- [new_cpoly_use_x_nonce](#new_cpoly_use_x_nonce)
- [new_cpoly_protector](#new_cpoly_protector)
- [AeadProtector](#AeadProtector)
- [CPoly](#CPoly)
  - [key_size](#key_size)
  - [nonce_size](#nonce_size)
  - [tag_size](#tag_size)
  - [aead_encrypt](#aead_encrypt)
  - [aead_decrypt](#aead_decrypt)
  - [verify](#verify)

## new_cpoly_use_x_nonce
```v
fn new_cpoly_use_x_nonce(use_x bool) &AeadProtector
```

creates new instance ChaCha20Poly1305 Aead protector use nonce size based on use_x flag.  
when true, its using extended nonce size, ie, 24 bytes..otherwise was using
standard nonce_size of 12 bytes.  

[[Return to contents]](#Contents)

## new_cpoly_protector
```v
fn new_cpoly_protector() &AeadProtector
```

creates ChaCha20Poly1305 aead protector with standard nonce size.  

[[Return to contents]](#Contents)

## AeadProtector
```v
interface AeadProtector {
	// nonce_size tell size of nonce input, in bytes, to underlying aead protector
	nonce_size() int
	// tag_size is size of the output of Aead message authenticated code (MAC) from
	// aead encrypt operation, in bytes.
	tag_size() int
	// key_size is size of key used for aead operation
	key_size() int
	// encrypt do encrypt and authenticated message to plaintext and additional data from given
	// secret_key and nonce, its return aead encrypted text plus message authentication code (mac)
	aead_encrypt(secret_key []u8, nonce []u8, plaintext []u8, additional_data []u8) ![]u8
	// decrypt do reverse of encrypt operation
	aead_decrypt(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8) ![]u8
	// verify was doing check and verify of the provided mac arguemnt by doing unprptect operation
	// and then compares mac's result and provided mac.
	verify(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8, mac []u8) !bool
}
```

AeadProtector is main interface for AEAD mechanism.  
For this time, this module only implement ChaCha2Poly1305 AEAD library backed by `chacha20poly1305`. see at [chacha20poly1305](https://github.com/blackshirt/chacha20poly1305.git)

[[Return to contents]](#Contents)

## CPoly
## key_size
```v
fn (c CPoly) key_size() int
```


[[Return to contents]](#Contents)

## nonce_size
```v
fn (c CPoly) nonce_size() int
```


[[Return to contents]](#Contents)

## tag_size
```v
fn (c CPoly) tag_size() int
```


[[Return to contents]](#Contents)

## aead_encrypt
```v
fn (c CPoly) aead_encrypt(secret_key []u8, nonce []u8, additional_data []u8, plaintext []u8) ![]u8
```


[[Return to contents]](#Contents)

## aead_decrypt
```v
fn (c CPoly) aead_decrypt(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8) ![]u8
```


[[Return to contents]](#Contents)

## verify
```v
fn (c CPoly) verify(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8, mac []u8) !bool
```


[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 28 Jul 2023 18:23:17

