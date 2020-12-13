import pandas as pd
import numpy as np


testDataFileName = r'data\data.txt'
fakeDataFileName = r'data\data_fake.txt'
trueDataFileName = r'data\data_true.txt'

outputFakeDataFileName = 'data_fake_result.txt'
outputTrueDataFileName = 'data_true_result.txt'


def getData(fileName):
    data = pd.read_csv(fileName, sep=':', header=None)
    data.columns = ['user_name', 'user_actions']
    data['user_actions'] = data['user_actions'].apply(lambda x: np.array(x.split(';'), dtype=np.uintc))
    return data


def checkUserBehavior(userName, actionSequence, behaviorModel, threshold):
    userBehaviorModel = behaviorModel[userName]
    currentUserBehavior = createUserBehaviorModel(actionSequence)
    for state in currentUserBehavior.keys():
        if state in userBehaviorModel:
            currentProbability = currentUserBehavior[state]
            if abs(userBehaviorModel[state] - currentProbability) > threshold:
                return 'fake'
        else:
            return 'fake'
    return 'real'


def createUserBehaviorModel(actionSequence):
    behaviorModel = dict()
    stateFreq = dict()
    N = len(actionSequence)

    for i in range(N - 1):
        state = (actionSequence[i], actionSequence[i + 1])
        first, second = state
        if first in stateFreq:
            stateFreq[first] += 1
        else:
            stateFreq[first] = 1
        if state in behaviorModel:
            behaviorModel[state] += 1
        else:
            behaviorModel[state] = 1

    for key in behaviorModel:
        first, second = key
        behaviorModel[key] /= stateFreq[first]

    return behaviorModel


def calculateAndPrintAccuracy(statistics, message):
    print(statistics.head())
    accuracy = statistics.loc[0, 'real_or_fake'] / (
            statistics.loc[0, 'real_or_fake'] + statistics.loc[1, 'real_or_fake'])
    print(message, accuracy)
    print('---------------------------------------------')


if __name__ == "__main__":
    testData = getData(testDataFileName)
    fakeData = getData(fakeDataFileName)
    trueData = getData(trueDataFileName)
    T = 0.5

    # Creation of user behavior model
    usersBehaviorModel = dict()
    testData.apply(lambda x: usersBehaviorModel.update({x['user_name']: createUserBehaviorModel(x['user_actions'])}), axis=1)

    # Fake data processing
    fakeData['real_or_fake'] = fakeData.apply(lambda x: checkUserBehavior(x['user_name'], x['user_actions'], usersBehaviorModel, T), axis=1)

    fakeStatistics = fakeData['real_or_fake'].value_counts().reset_index()
    calculateAndPrintAccuracy(fakeStatistics, 'Accuracy in case of fake users:')

    # True data processing
    trueData['real_or_fake'] = trueData.apply(lambda x: checkUserBehavior(x['user_name'], x['user_actions'], usersBehaviorModel, T), axis=1)

    realStatistics = trueData['real_or_fake'].value_counts().reset_index()
    calculateAndPrintAccuracy(realStatistics, 'Accuracy in case of real users:')