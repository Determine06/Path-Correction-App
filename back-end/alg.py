from importlib.machinery import all_suffixes
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore 
import math
import threading
from datetime import datetime
import numpy as np
from matplotlib import pyplot as plt
from sklearn.linear_model import LinearRegression


class backend():
    def __init__(self):
        self.data = {}
        
    def alorithm(p1, p2, p3):
        meanX = (p1[0] + p2[0] + p3[0]) / 3
        madX = (math.abs(p1[0] - meanX) + math.abs(p2[0] - meanX) + math.abs(p3[0] - meanX)) / 3
        meanY = (p1[1] + p2[1] + p3[1]) / 3
        madY = (math.abs(p1[1] - meanY) + math.abs(p2[1] - meanY) + math.abs(p3[1] - meanY)) / 3

    def shortest_distance(x1, y1, a, b, c):
        return (abs((a * x1 + b * y1 + c)) / (math.sqrt(a * a + b * b)))
                 
    def getData(self):
        counter = 0
        cred = credentials.Certificate('serviceAccountKey.json')
        firebase_admin.initialize_app(cred)
        db = firestore.client()
        
        while True:            
            thread = threading.Thread()
            thread.start()
            doc_ref = db.collection(u'coordinates').document(str(counter))
            doc = doc_ref.get()
            
            if doc.exists:
                now = datetime.now()
                dict = doc.to_dict()
                dict["beTimeStamp"] = now
                self.data[str(counter)] = dict 
                counter += 1
                
                if counter == 14:
                    self.lineOfBestFit()
                    
            else:
                print(f"looking for id --> {counter}")
                
                
    def lineOfBestFit(self):
        arr = []
        for i in range(0, len(self.data)):
            arr.append([float(self.data[str(i)]["lat"]), float(self.data[str(i)]["long"])])
        dt = np.array(arr, float)

        # Preparing the data to be computed and plotted
        '''dt = np.array([
                [1, 1.2],
                [2, 2.3],
                [3, 2.8],
                [4, 4.24],
                [5, 4.94],
                [6, 5]
        ])'''

        # Preparing X and y from the given data
        X = dt[10:, 0]
        y = dt[10:, 1]
        print(len(X))
        allX = dt[:, 0]
        allY = dt[:, 1]
        # Calculating parameters (Here, intercept-theta1 and slope-theta0)
        # of the line using the numpy.polyfit() function
        theta = np.polyfit(X, y, 1)

        print(f'The parameters of the line: {theta}')

        # Now, calculating the y-axis values against x-values according to
        y_line = theta[1] + theta[0] * X
        #print(theta[0], theta[1])
        #print(self.shortest_distance(dt[5][0], dt[5][1], theta[0], -1, theta[1]))
        # Plotting the data points and the best fit line
        plt.scatter(allX, allY)
        plt.plot(X, y_line, 'r')
        plt.title('Best fit line')
        plt.xlabel('x-axis')
        plt.ylabel('y-axis')

        plt.show()


b = backend()
b.getData()