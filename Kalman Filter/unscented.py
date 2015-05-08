import numpy as np
import matplotlib.pyplot as plt
import kalman

T = 0.01 # sampling step

# Expects row vectors
def system_func(x, v):
	return x + np.array([x[3]*np.cos(x[2])*T, x[3]*np.sin(x[2])*T, 0, 0]) + np.array([0, v[0], 0, v[1]])

def meas_func(x, n):
	return np.array([x[0], x[2]])

x = np.arange(0, 10, 0.01)
y = np.concatenate((np.ones(499), np.linspace(1, 0, 501)))

Y = np.vstack((x, y))
Z = Y + 0.1*np.random.standard_normal(Y.shape)



A = np.array([[1, T, 0, 0], [0, 1, 0, 0], [0, 0, 1, T], [0, 0, 0, 1]])
C = np.array([[1, 0, 0, 0], [0, 0, 1, 0]])
Q = np.array([[0, 0, 0, 0], [0, 0.0001, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0.0001]])
R = np.eye(2)

P0 = 100*np.eye(4)

(Xfilt, P) = kalman.linear_filter(Z, A, C, Q, R, initial_cov = P0)

Zfilt = C.dot(Xfilt)

fig1 = plt.figure()
ax1 = fig1.add_subplot(111)
ax1.plot(Y[0, :], Y[1, :])
ax1.plot(Z[0, :], Z[1, :], marker='x', color='r', linestyle='None')

fig2 = plt.figure()
ax2 = fig2.add_subplot(111)
ax2.plot(Y[0, :], Y[1, :])
ax2.plot(Zfilt[0, :], Zfilt[1, :], color='r')

plt.show()