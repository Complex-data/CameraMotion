import numpy as np

# Implementation of a normal Kalman filter
def linear_filter(Z, A, C, Q, R, initial_state = None, initial_cov = None):
	(p, N) = Z.shape # N = number of samples, p = number of "sensors"
	n = A.shape[0] # n = order of the system

	Xpred = np.zeros((n, N + 1)) # Kalman predicted state
	Xfilt = np.zeros((n, N + 1)) # Kalman filtered state

	if initial_state is None:
		initial_state = np.zeros(n) # Default initial states

	if initial_cov is None:
		initial_cov = np.eye(n) # Default initial covariance

	# Filter initialization
	Xfilt[:, 0] = initial_state # Measurements available at time 0
	P = initial_cov # Initial uncertainty

	Xpred[:, [0]] = A.dot(Xfilt[:, [0]])
	P = A.dot(P.dot(A.T)) + Q # Uncertainty update

	# Kalman filter iterations
	for t in range(1, N + 1):
		Xfilt[:, [t]] = Xpred[:, [t - 1]] + P.dot(C.T).dot(np.linalg.inv(C.dot(P.dot(C.T)) + R)).dot(Z[:, [t - 1]] - C.dot(Xpred[:, [t - 1]])) # Filter update

		P = P - P.dot(C.T).dot(np.linalg.inv(C.dot(P.dot(C.T)) + R)).dot(C).dot(P) # Uncertainty update

		Xpred[:, [t]] = A.dot(Xfilt[:, [t]]) # Prediction
		P = A.dot(P.dot(A.T)) + Q # Uncertainty update
	
	return Xfilt, P

def unscented_filter(initial_state = None, initial_cov = None):
	if initial_state is None:
		initial_state = np.zeros(n) # Default initial states

	if initial_cov is None:
		initial_cov = np.eye(n) # Default initial covariance

	