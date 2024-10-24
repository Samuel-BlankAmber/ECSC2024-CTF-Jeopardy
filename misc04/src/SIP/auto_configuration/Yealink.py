from Crypto.Cipher import AES, PKCS1_v1_5
from Crypto.PublicKey import RSA
from hashlib import md5
import random
from base64 import b64encode, b64decode
from Crypto.Util.number import long_to_bytes, bytes_to_long
import os

class Yealink():

    def __init__(self, sessid:str):
        self.sessid=sessid
    
    def ylform_rsa_encrypt(self, data:bytes):
        data = self.sessid.encode()+b";"+data
        return self.rsa_encrypt(data).hex()

    def rsa_encrypt(self, data:bytes):
        data = b"\x00"+data
        pad = b"\x00\x02"+os.urandom(((self.n.bit_length()+7)>>3)-len(data)).replace(b"\x00", b"\xff")[2:]
        data = pad+data
        data = bytes_to_long(data)
        c = pow(data, self.e, self.n)
        return long_to_bytes(c)
    
    def initEncrypt(self, n:int, e:int):
        self.n = n
        self.e = e
        objencrypt={}
        objencrypt["aesmode"] = AES.MODE_CBC
        r = md5()
        r.update(str(random.random()).encode())
        r = r.hexdigest()
        objencrypt["datakey"] = self.rsa_encrypt(r.encode()).hex()
        objencrypt["key"] = bytes.fromhex(r)
        n = md5()
        n.update(str(random.random()).encode())
        n = n.hexdigest()
        objencrypt["dataiv"] = self.rsa_encrypt(n.encode()).hex()
        objencrypt["aesiv"] = bytes.fromhex(n)
        self.objencrypt = objencrypt
    
    def aesEncrypt(self,data:bytes,key:bytes):
        data = data+b"\x00"*(16-(len(data)%16))
        cipher = AES.new(key, self.objencrypt["aesmode"], iv=self.objencrypt["aesiv"])
        enc = cipher.encrypt(data)
        return b64encode(enc).decode()

    def encrypt(self, data:bytes):
        t = str(random.random()).encode()+b";"+self.sessid.encode()+b";"+data
        return self.aesEncrypt(t,self.objencrypt["key"])

