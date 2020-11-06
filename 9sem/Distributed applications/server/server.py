import socket
import pickle
from skimage.io import imsave
from skimage import img_as_ubyte
from skimage.restoration import denoise_bilateral
import ssl
import logging

clientImageName = 'imageFromClient.png'
processedImageName = 'imageFromClientWithoutNoise.png'
host = 'localhost'
port = 8086
chunkSize = 4096


class ImageInfo:
    def __init__(self, imageHeight, imageWidth, imageName, image):
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.imageName = imageName
        self.image = image


def filterNoiseAndSaveImage(imageWithNoise):
    processedImage = denoise_bilateral(imageWithNoise, sigma_color=0.05, sigma_spatial=15, multichannel=True)
    imsave(processedImageName, img_as_ubyte(processedImage))
    logging.info('Image without noise was created')


def sendResponse(connect, responseCode=0):
    if responseCode == 0:
        connect.send('OK'.encode())
    else:
        connect.send('BAD'.encode())


def recieveRequests(connect):
    dataSize = int(connect.recv(chunkSize).decode())
    logging.info('Received data size: \'' + str(dataSize) + '\'')
    sendResponse(connect)
    currentSize = 0
    data = b''
    callsNumber = 0

    while True:
        while currentSize < dataSize:
            chunk = connect.recv(chunkSize)
            if not chunk or chunk == 'STOP'.encode():
                break
            currentSize += len(chunk)
            data += chunk
        if (currentSize != dataSize):
            logging.error('Data was corrupted. Server is trying to get data again.')
            sendResponse(connect, 1)
            callsNumber += 1
        else:
            chunk = connect.recv(chunkSize)
            break
        if callsNumber > 10:
            tmp =
            while len(data) < dataSize:
                x = len(data)
                data += tmp
            logging.error('Current connection is unavailable. Please, try next time')
            break

    data = pickle.loads(data)
    logging.info('Received image with name: \'' + str(data.imageName) + '\' ans size: \'' + str(data.imageHeight) + 'x'
                 + str(data.imageWidth) + '\'')
    imsave(clientImageName, img_as_ubyte(data.image))
    logging.info('Original image was saved into file: \'' + clientImageName + '\'')
    sendResponse(connect)
    #filterNoiseAndSaveImage(data.image)
    logging.info('Image without noise was saved into file: \'' + processedImageName + '\'')


if __name__ == "__main__":
    with socket.socket() as socket:
        with ssl.wrap_socket(socket, 'private.key', 'self_signed.crt', True) as s_socket:
            logging.basicConfig(level=logging.INFO, format="[Server logs] - %(message)s")
            s_socket.bind((host, port))
            s_socket.listen(1)
            logging.info('Server is running')
            connect, address = s_socket.accept()
            logging.info('Connection was established successfully. Address of connected client: ' + str(address))

            recieveRequests(connect)

            logging.info('Connection for client ' + str(address) + ' was closed')
            logging.info('Server finished it\'s work')