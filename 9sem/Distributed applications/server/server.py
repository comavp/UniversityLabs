import socket
import pickle
from skimage.io import imsave, imread
from skimage import img_as_ubyte
from skimage.restoration import denoise_bilateral, denoise_wavelet
import ssl
import logging

clientImageName = 'imageFromClient.png'
processedImageName = 'imageFromClientWithoutNoise.png'
host = 'localhost'
port = 8086
chunkSize = 4096


class ImageInfo:
    def __init__(self, imageHeight, imageWidth, imageName, imageSize):
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.imageName = imageName
        self.imageSize = imageSize


def filterNoiseAndSaveImage(imageWithNoise):
    try:
        processedImage = denoise_wavelet(imageWithNoise, multichannel=True, rescale_sigma=True)
        imsave(processedImageName, img_as_ubyte(processedImage))
        logging.info('Image without noise was saved into file: \'' + processedImageName + '\'')
    except Exception:
        logging.error('Something went wrong during image with noise processing.')


def sendResponse(connect, responseCode=0):
    if responseCode == 0:
        connect.send('OK'.encode())
    else:
        connect.send('BAD'.encode())


def recieveImageInfo(connect, dataSize):
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
            sendResponse(connect)
            break
        if callsNumber > 10:
            logging.error('Current connection is unavailable. Please, try next time')
            break

    return pickle.loads(data)


def recieveAndSaveImage(connect, imageSize):
    currentSize = 0
    data = b''
    while currentSize < imageSize:
        chunk = connect.recv(chunkSize)
        if not chunk or chunk == 'STOP'.encode():
            break
        currentSize += len(chunk)
        data += chunk
    sendResponse(connect)
    if (currentSize != imageSize):
        logging.error('Image was corrupted. Server is trying to recover image.')
        data += ''.ljust(imageSize - currentSize, '0').encode()
    else:
        logging.info('Server received image successfully')
    file = open(clientImageName, 'wb')
    file.write(data)
    file.close()
    return True


def receiveRequests(connect):
    dataSize = int(connect.recv(chunkSize).decode())
    logging.info('Received data size: \'' + str(dataSize) + '\'')
    sendResponse(connect)

    imageInfo = recieveImageInfo(connect, dataSize)
    logging.info('Received image info (name: \'' + str(imageInfo.imageName) + '\' and size: \'' + str(imageInfo.imageHeight) + 'x'
                 + str(imageInfo.imageWidth) + '\')')
    isRecieved = recieveAndSaveImage(connect, imageInfo.imageSize)
    logging.info('Original image was saved into file: \'' + clientImageName + '\'')
    sendResponse(connect)
    if (isRecieved):
        pass
        #filterNoiseAndSaveImage(imread(clientImageName))
    else:
        logging.error('File with image from client was not found')


if __name__ == "__main__":
    with socket.socket() as socket:
        with ssl.wrap_socket(socket, 'private.key', 'self_signed.crt', True) as s_socket:
            logging.basicConfig(level=logging.INFO, format="[Server logs] - %(message)s")
            s_socket.bind((host, port))
            s_socket.listen(1)
            logging.info('Server is running')
            connect, address = s_socket.accept()
            logging.info('Connection was established successfully. Address of connected client: ' + str(address))

            receiveRequests(connect)

            logging.info('Connection for client ' + str(address) + ' was closed')
            logging.info('Server finished it\'s work')