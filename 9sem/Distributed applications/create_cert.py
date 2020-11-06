from OpenSSL import crypto, SSL
import random

CERT_FILE = "server/self_signed.crt"
KEY_FILE = "server/private.key"
random_serial_number = random.getrandbits(64)


def create_self_signed_cert():

    # create a key pair
    k = crypto.PKey()
    k.generate_key(crypto.TYPE_RSA, 2048)

    # create a self-signed cert
    cert = crypto.X509()
    cert.get_subject().C = "RU"
    cert.get_subject().ST = "Moscow"
    cert.get_subject().L = "Samara"
    cert.get_subject().O = "Test1"
    cert.get_subject().OU = "Test2"
    cert.get_subject().CN = "localhost"
    cert.set_serial_number(random_serial_number)
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(10*365*24*60*60)
    cert.set_issuer(cert.get_subject())
    cert.set_pubkey(k)
    cert.sign(k, 'sha512')

    open(CERT_FILE, "wt").write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert).decode('utf-8'))
    open(KEY_FILE, "wt").write(crypto.dump_privatekey(crypto.FILETYPE_PEM, k).decode('utf-8'))


if __name__ == "__main__":
    create_self_signed_cert()