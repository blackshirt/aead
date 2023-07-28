module aead

// 2.8.1.  Example and Test Vector for AEAD_CHACHA20-POLY1305
// taken from https://datatracker.ietf.org/doc/html/draft-nir-cfrg-chacha20-poly1305#autoid-18
import encoding.hex
import chacha20

fn test_cpoly_protector() ! {
	plaintext := "Ladies and Gentlemen of the class of '99: If I could offer you only one tip forthe future, sunscreen would be i"
	plaintext_bytes := [u8(0x4c), 0x61, 0x64, 0x69, 0x65, 0x73, 0x20, 0x61, 0x6e, 0x64, 0x20, 0x47,
		0x65, 0x6e, 0x74, 0x6c, 0x65, 0x6d, 0x65, 0x6e, 0x20, 0x6f, 0x66, 0x20, 0x74, 0x68, 0x65,
		0x20, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x20, 0x6f, 0x66, 0x20, 0x27, 0x39, 0x39, 0x3a, 0x20,
		0x49, 0x66, 0x20, 0x49, 0x20, 0x63, 0x6f, 0x75, 0x6c, 0x64, 0x20, 0x6f, 0x66, 0x66, 0x65,
		0x72, 0x20, 0x79, 0x6f, 0x75, 0x20, 0x6f, 0x6e, 0x6c, 0x79, 0x20, 0x6f, 0x6e, 0x65, 0x20,
		0x74, 0x69, 0x70, 0x20, 0x66, 0x6f, 0x72, 0x20, 0x74, 0x68, 0x65, 0x20, 0x66, 0x75, 0x74,
		0x75, 0x72, 0x65, 0x2c, 0x20, 0x73, 0x75, 0x6e, 0x73, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x20,
		0x77, 0x6f, 0x75, 0x6c, 0x64, 0x20, 0x62, 0x65, 0x20, 0x69, 0x74, 0x2e]

	// PQRS........
	aad := [u8(0x50), 0x51, 0x52, 0x53, 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7]
	key := [u8(0x80), 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d,
		0x8e, 0x8f, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c,
		0x9d, 0x9e, 0x9f]

	// iv
	iv := [u8(0x40), 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47]
	fixed := [u8(0x07), 0x00, 0x00, 0x00]

	expected_otk := hex.decode('7bac2b252db447af09b67a55a4e955840ae1d6731075d9eb2a9375783ed553ff') or {
		panic(err.msg())
	}

	mut nonce := []u8{}
	nonce << fixed
	nonce << iv

	otk := chacha20.otk_key_gen(key, nonce)!
	assert otk == expected_otk

	expected_ciphertext := hex.decode('d31a8d34648e60db7b86afbc53ef7ec2a4aded51296e08fea9e2b5a736ee62d63dbea45e8ca9671282fafb69da92728b1a71de0a9e060b2905d6a5b67ecd3b3692ddbd7f2d778b8c9803aee328091b58fab324e4fad675945585808b4831d7bc3ff4def08e4b7a9de576d26586cec64b6116') or {
		panic(err.msg())
	}
	expected_tag := hex.decode('1ae10b594f09e26a7e902ecbd0600691') or { panic(err.msg()) }

	protector := new_cpoly_protector()
	out := protector.aead_encrypt(key, nonce, aad, plaintext_bytes)!

	ciphertext := out[..out.len - protector.tag_size()]
	mac := out[out.len - protector.tag_size()..]
	assert ciphertext == expected_ciphertext
	assert mac == expected_tag
}
