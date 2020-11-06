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
    def __init__(self, imageHeight, imageWidth, imageName, image):
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.imageName = imageName
        self.image = image


def addNoiseToImageAndSave(image):
    imageWithNoise = random_noise(image, var=0.155**2)
    imsave(imageWithNoiseName, img_as_ubyte(imageWithNoise))
    return imageWithNoise


def getResponse(s_sock):
    response = s_sock.recv(chunkSize).decode()
    logging.info('Request processing is finished with response: ' + str(response))
    return str(response)


def sendRequest(s_sock):
    image = imread(imageName)
    imageWithNoise = addNoiseToImageAndSave(image)
    width, height, numberOfColorChannels = image.shape
    imageInfo = ImageInfo(height, width, imageName, imageWithNoise)
    dataToSend = pickle.dumps(imageInfo)

    size = len(dataToSend)
    s_sock.send(str(size).encode())
    logging.info('Client sent data size(' + str(size) + ') to server')
    if 'OK' == getResponse(s_sock):
        isImageReceived = False
        while not isImageReceived:
            #s_sock.send(dataToSend)
            logging.info('Client sent image with name: \'' + imageInfo.imageName + '\'')
            s_sock.send('STOP'.encode())
            if getResponse(s_sock) == 'OK':
                isImageReceived = True



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
            except Exception:
                logging.error('Client finished it\'s work due to unexpected exception')