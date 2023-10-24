module aead

import crypto.internal.subtle
import blackshirt.chacha20poly1305

// Authenticated Encryption with Associated Data (AEAD)
// An AEAD algorithm has two operations, authenticated encryption and authenticated decryption

// Cipher is main interface for AEAD mechanism.
// For this time, this module only implement ChaCha2Poly1305 AEAD library
// backed by `chacha20poly1305`. see at [chacha20poly1305](https://github.com/blackshirt/chacha20poly1305.git)
pub interface Cipher {
	// nonce_size tell size of nonce input, in bytes, to underlying aead protector
	nonce_size() int
	
	// tag_size is size of the output of Aead message authenticated code (MAC) from
	
	// aead encrypt operation, in bytes.
	tag_size() int
	
	// key_size is size of key used for aead operation
	key_size() int
	
	// encrypt do encrypt and authenticated message to plaintext and additional data from given
	// secret_key and nonce, its return aead encrypted text and message authentication code (mac)
	encrypt(secret_key []u8, nonce []u8, plaintext []u8, additional_data []u8) !([]u8, []u8)
	
	// decrypt do reverse of encrypt operation, its returns plaintext and associated tag (mac)
	decrypt(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8) !([]u8, []u8)
	
	// verify was doing check and verify of the provided mac arguemnt by doing unprptect operation
	// and then compares mac's result and provided mac. Its return plaintext and validity of tag (mac) result.
	// Its should return true on matching, and false otherwise
	decrypt_and_verify(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8, mac []u8) !([]u8, bool)
}

// ChaCha20Poly1305 Aead Cipher implementation
struct Chacha20Poly1305 {
	with_x_nonce bool
}

// creates new instance ChaCha20Poly1305 AEAD Cipher use nonce size based on with_x_nonce flag.
// when true, its using extended nonce size, ie, 24 bytes..otherwise was using
// standard nonce_size of 12 bytes.
pub fn new_chacha20poly1305_cipher(with_x_nonce bool) &Cipher {
	return &Chacha20Poly1305{
		with_x_nonce: with_x_nonce
	}
}

// new_default_chacha20poly1305_cipher creates ChaCha20Poly1305 AEAD cipher with standard nonce size.
pub fn new_default_chacha20poly1305_cipher() &Cipher {
	cpoly := new_chacha20poly1305_cipher(false)
	return cpoly
}

pub fn (c Chacha20Poly1305) key_size() int {
	return chacha20poly1305.key_size
}

pub fn (c Chacha20Poly1305) nonce_size() int {
	if c.with_x_nonce {
		return chacha20poly1305.x_nonce_size
	}
	// otherwise its 12 nonce_size
	return chacha20poly1305.nonce_size
}

pub fn (c Chacha20Poly1305) tag_size() int {
	return chacha20poly1305.tag_size
}

		pub fn (c Chacha20Poly1305) encrypt(secret_key []u8, nonce []u8, additional_data []u8, plaintext []u8) !([]u8, []u8) {
	ciphertext, mac := chacha20poly1305.aead_encrypt(secret_key, nonce, additional_data, plaintext)!
	
	return ciphertext, mac
}

pub fn (c Chacha20Poly1305) decrypt(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8) !([]u8, []u8) {
	plaintext, tag := chacha20poly1305.aead_decrypt(secret_key, nonce, additional_data, ciphertext)!
	
	return plaintext, tag
}

pub fn (c Chacha20Poly1305) decrypt_and_verify(secret_key []u8, nonce []u8, additional_data []u8, ciphertext []u8, mac []u8) !([]u8, bool) {
	plaintext, tag := c.decrypt(secret_key, nonce, additional_data, ciphertext)!
	valid := subtle.constant_time_compare(tag, mac) == 1
	return plaintext, valid
}
