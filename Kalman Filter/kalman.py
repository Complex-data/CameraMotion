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

def unscented_filter(system_func, meas_func, meas, system_order, system_noise_order, meas_noise_order, alpha = None, beta = None, kappa = None, initial_state = None, initial_system_cov = None, initial_system_noise_cov = None, initial_meas_noise_cov = None):
	# Set default parameter values
	if alpha is None:
		alpha = 1

	if beta is None:
		beta = 2

	if kappa = None:
		kappa = 0

	if initial_state is None:
		initial_state = np.zeros(system_oder) # Default initial states

	if initial_system_cov is None:
		initial_cov = np.eye(system_oder) # Default initial covariance

	if initial_system_noise_cov is None:
		system_noise_order = 2
		initial_system_noise_cov = 0.0001*np.eye(2)

	if initial_meas_noise_cov is None:
		meas_noise_order = 2
		initial_meas_noise_cov = np.eye(2)

	(p, N) = meas.shape # N = number of new measurements

	total_order = system_order + system_noise_order + meas_noise_order
	lam = alpha*alpha*(total_order + kappa) - total_order

	# Kalman predicted state
	Xpred = np.zeros((total_order, 1))
	# Sigma points for the unscented transform
	sigma_points = np.zeros((total_order, 2*total_order + 1)) 
	# Kalman filtered state
	Xfilt = np.zeros((total_order, N + 1))

	# Initialise
	Xfilt[:, 0] = initial_state
	P = initial_system_cov
	Xaug = np.concatenate((Xfilt[:, 0], np.zeros(system_noise_order + meas_noise_order)))
	Paug = np.zeros((total_order, total_order))

	# Construct initial augmented covariance matrix
	Paug[0:system_order, 0:system_order] = P
	Paug[system_order:(system_oder + system_noise_order), system_order:(system_oder + system_noise_order)] = initial_system_noise_cov
	Paug[(system_oder + system_noise_order):total_order, (system_oder + system_noise_order):total_order] = initial_meas_noise_cov

	c = np.sqrt(total_order + lam)

	L = c*np.linalg.cholesky(Paug)
	