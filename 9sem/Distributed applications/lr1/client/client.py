import socket
import pickle
from skimage.io import imread, imsave
from skimage import img_as_ubyte
from skimage.util import random_noise
import ssl
import logging

host = 'localhost'
port = 8086
imageName = 'image.png'
imageWithNoiseName = 'imageWithNoise.png'
chunkSize = 4096


class ImageInfo:
    def __init__(self, imageHeight, imageWidth, imageName, imageSize):
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.imageName = imageName
        self.imageSize = imageSize


def addNoiseToImageAndSave(image):
    imageWithNoise = random_noise(image, var=0.155**2)
    imsave(imageWithNoiseName, img_as_ubyte(imageWithNoise))
    return imageWithNoise


def getResponse(s_sock):
    response = s_sock.recv(chunkSize).decode()
    logging.info('Request processing is finished with response: ' + str(response))
    return str(response)


def sendImageInfo(s_sock, dataToSend):
    isImageInfoReceived = False
    while not isImageInfoReceived:
        s_sock.send(dataToSend)
        logging.info('Client sent image info')
        s_sock.send('STOP'.encode())
        if getResponse(s_sock) == 'OK':
            isImageInfoReceived = True
    logging.info('Server successfully received image info')


def sendImage(s_sock, imageAsStringOfBytes, imageName):
    #corruptedImage1 = imageAsStringOfBytes[:len(imageAsStringOfBytes) - 1000] + imageAsStringOfBytes[len(imageAsStringOfBytes) - 500:]
    corruptedImage = imageAsStringOfBytes[:len(imageAsStringOfBytes) - 30000]
    s_sock.sendall(corruptedImage)
    logging.info('Client sent image with name: \'' + imageName + '\'')
    s_sock.send('STOP'.encode())
    if getResponse(s_sock) == 'OK':
        logging.info('Server successfully received image with name: \'' + imageName + '\'')
    else:
        logging.error('Internal server error.')


def sendRequest(s_sock):
    image = imread(imageName)
    imageWithNoise = addNoiseToImageAndSave(image)
    file = open(imageWithNoiseName, 'rb')
    imageAsStringOfBytes = b''
    while True:
        chunk = file.read(chunkSize)
        if not chunk: break
        imageAsStringOfBytes += chunk
    file.close()

    width, height, numberOfColorChannels = imageWithNoise.shape
    imageInfo = ImageInfo(height, width, imageName, len(imageAsStringOfBytes))
    dataToSend = pickle.dumps(imageInfo)

    size = len(dataToSend)
    s_sock.send(str(size).encode())
    logging.info('Client sent data size(' + str(size) + ') to server')
    if 'OK' == getResponse(s_sock):
        sendImageInfo(s_sock, dataToSend)
        sendImage(s_sock, imageAsStringOfBytes, imageName)


if __name__ == "__main__":
    with socket.socket() as socket:
        with ssl.wrap_socket(socket) as s_sock:
            logging.basicConfig(level=logging.INFO, format="[Client logs] - %(message)s")
            try:
                s_sock.connect((host, port))
                sendRequest(s_sock)
                logging.info('Client finished it\'s work')
            except ConnectionRefusedError:
                logging.error('Connection to server with host=\'' + str(host) + '\' and port=\'' + str(port) +
                      '\' cannot be established')
            #except Exception:
                #logging.error('Client finished it\'s work due to unexpected exception')